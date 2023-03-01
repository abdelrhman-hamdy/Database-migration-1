pipeline{
    agent any  
 
    environment{
        AWS_ACCESS_KEY_ID=credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY=credentials('jenkins-aws-secret-access-key')
        AWS_REGION= "us-east-1"
        MONGO_DB_PASSWORD=credentials('mongo-db-password')
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
                sh 'cd IaC/dev;../../AddServerIPtoInventory.sh mongodb ../../ConfigurationManagement/inventory '
                sh 'cd IaC/dev;../../AddServerIPtoInventory.sh mockserver ../../ConfigurationManagement/inventory'
                sh 'cd IaC/dev;../../AddServerIPtoInventory.sh ServerPrivateIp ../../ConfigurationManagement/inventory'               
                echo "========Configuring Mongodb and Mockserver ========"
                sh ''' 
                    ./GetVarsForClient.sh ${MONGO_DB_PASSWORD} mongodb
                    cd ConfigurationManagement
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mongodb.yml --vault-password-file ../ansibleVault
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  mockserver.yml --vault-password-file ../ansibleVault
                '''
                
                
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
    

