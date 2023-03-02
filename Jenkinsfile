pipeline{
    agent any  
 
    environment{
        AWS_ACCESS_KEY_ID=credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY=credentials('jenkins-aws-secret-access-key')
        AWS_REGION= "us-east-1"
        DB_PASSWORD=credentials('mongo-db-password')
        DB_USERNAME="hamdy"
        TF_VAR_db_password="${DB_PASSWORD}" 
        TF_VAR_db_username="${DB_USERNAME}"
        TF_VAR_keyname="hamdy_key"
    }
    stages{
        stage("Checkout"){
                
            steps{
                echo "========Checkout Github repo========"
                //git branch: 'main', url: 'https://github.com/abdelrhman-hamdy/Database-migration-1.git'
            }}
        stage("Pre-work"){
            steps{
                echo "========Deploy pre-work Infrastructure========"

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
                script{
                Mongodb_public_ip= sh(script:'cd IaC/dev;../../scripts/AddServerIPtoInventory.sh mongodb ../../ConfigurationManagement/inventory', returnStdout: true)
                }
                echo "REBNA YOUSETER 1 :${Mongodb_public_ip}"
                script{ 
                MockServer_public_ip= sh(script:'cd IaC/dev;../../scripts/AddServerIPtoInventory.sh mockserver ../../ConfigurationManagement/inventory', returnStdout: true)
                }

                echo "REBNA YOUSETER  2 : ${MockServer_public_ip}"

                script{
                MockServer_private_ip=sh(script:'cd IaC/dev;../../scripts/AddServerIPtoInventory.sh ServerPrivateIp ../../ConfigurationManagement/inventory',  returnStdout: true)          
                }

                echo "REBNA YOUSETER 3: ${MockServer_private_ip}"
                environment {
                   Mongodb_public_ip="${Mongodb_public_ip}"
                    MockServer_public_ip="${MockServer_public_ip}"
                    MockServer_private_ip="${MockServer_private_ip}"
                }
                echo "========Configuring Mongodb and Mockserver ========"
                sh ''' 
                    ./scripts/GetVarsForMongoClient.sh 
                    cd ConfigurationManagement
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mongodb.yml --vault-password-file ../ansibleVault
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mockserver.yml --vault-password-file ../ansibleVault
                '''

                echo "========Testing That Client reads data from server and inserts in the database ========"
                sh '''
                    . Testing/TestClientInsertDataToDB.sh   # smoke testing of the system 
                    '''

                echo "======== Provisioning Mysql RDS ========"
                sh '''  cd IaC/dev
                        terraform init
                        terraform apply -target=module.Mysql -auto-approve
                         '''
                
                echo "========Deploy the new client ========"
                script{
                    Mysql_endpoint=sh (script:'./scripts/GetVarsForMysqlClient.sh',  returnStdout: true)
                }
                echo "REBNA YOUSETER  2 : ${Mysql_endpoint}"

                sh '''cd ConfigurationManagement
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  MysqlClient.yml'''
            }}}
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                    sh 'cd IaC/dev;terraform destroy -auto-approve'
                }
            }
        }
    

