pipeline{
    agent any  
 
    environment{
        AWS_ACCESS_KEY_ID=credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY=credentials('jenkins-aws-secret-access-key')
        AWS_REGION= "us-east-1"
        DB_PASSWORD=credentials('db-password')
        DB_USERNAME="hamdy"
        TF_VAR_db_password="${DB_PASSWORD}" 
        TF_VAR_db_username="${DB_USERNAME}"
        TF_VAR_keyname="hamdy_key"
    }
    stages{
        stage("Checkout"){
            steps{
                echo "========Checkout Github repo========"
                git branch: 'main', url: 'https://github.com/abdelrhman-hamdy/Database-migration-1.git'

            }}
        stage("Deploy old system"){
            steps{
                echo "========Deploy old system========"

                echo "========Loading Required credentials========"
                withCredentials([sshUserPrivateKey(credentialsId: 'hamdy_key', keyFileVariable: 'hamdy_key'),
                                 file(credentialsId: 'ansible_password', variable: 'ansibleVaultKeyFile')]) {
                   sh 'cp ${hamdy_key} ./hamdy_key.pem' 
                 sh 'cp ${ansibleVaultKeyFile} ./ansibleVault' 
                }

                echo "========Provisioning Infrastructure========"
                sh '''  cd IaC/dev
                        terraform init
                        terraform apply -target=module.MongodbServer -target=module.MockServer  -auto-approve
                         '''

                echo "========Creating Inventory File========"
                sh'cd IaC/dev;../../scripts/AddServerIPtoInventory.sh mongodb mockserver ServerPrivateIp ../../ConfigurationManagement/inventory'  

                echo "========Configuring Mongodb and Mockserver ========"
                sh ''' 
                    ./scripts/GetVarsForMongoClient.sh mongodb
                    cd ConfigurationManagement
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mongodb.yml --vault-password-file ../ansibleVault
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mockserver.yml --vault-password-file ../ansibleVault
                '''
            }
        }
        stage("Testing the old system") { 
            steps{
                echo "========Testing That Client reads data from server and inserts in the database ========"
                sh '''
                     export dbhost=$(grep dbhost ConfigurationManagement/roles/run_Server_client/files/.env | cut -d= -f2)
                     ./Testing/TestClientInsertDataToDB.sh   # smoke testing of the system 
                    '''
            }
        }
        stage("Provisioning and Configuring the new system"){
            steps{
                echo "======== Provisioning Mysql RDS ========"
                sh '''  cd IaC/dev
                        terraform init
                        terraform apply -target=module.Mysql -auto-approve
                         '''
        
                echo "========Deploy the new client ========" 
                sh'./scripts/GetVarsForMysqlClient.sh'
                sh '''cd ConfigurationManagement;ansible-playbook -i inventory --private-key ../hamdy_key.pem  MysqlClient.yml'''
            }
        }
        stage("Testing New system"){

            steps{
                echo "========Testing That Client reads data from server and inserts in the database ========"
                sh '''
                     export dbhost=$(grep dbhost ConfigurationManagement/roles/run_mysql_client/files/.Mysqlenv | cut -d= -f2)
                     ./Testing/TestingMysqlClientInsertDataToDB.sh   # smoke testing of the system 
                    '''
            }
        }
        stage("Disconnecting mongo client from inserting data to the database"){
            steps{
                sh '''cd ConfigurationManagement;ansible-playbook -i inventory --private-key ../hamdy_key.pem  DisconnectMongoClient.yml'''

            }
        }

        stage("Migration"){
            steps{
                sh '''
                export mysqlhost=$(sed -n '/dbhost=.*/p' ./ConfigurationManagement/roles/run_mysql_client/files/.Mysqlenv | cut -d= -f2)
                export mongohost=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=MongodbServer" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text)
                echo $mongohost
                python3 ./scripts/MigrationScript.py
                '''
            }
        }
        stage("Testing that data Migrated Successfully"){
            steps{
                sh '''
                export mysqlhost=$(sed -n '/dbhost=.*/p' ./ConfigurationManagement/roles/run_mysql_client/files/.Mysqlenv | cut -d= -f2)
                export mongohost=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=MongodbServer" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text)
                echo $mongohost
                python3 ./Testing/TestIfMigrationWasSuccessful.py
                '''
                
            }
        } 
        stage("Destroy mongodb database"){
            steps{
                sh 'terraform destroy -target=module.MongodbServer'
            }
        }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                    //sh 'cd IaC/dev;terraform destroy -auto-approve'
                }
                failure{
                    echo "========A execution failed========"
                    //sh 'cd IaC/dev;terraform destroy -auto-approve'
                }
            }
        }