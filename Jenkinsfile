pipeline{
    agent any  
 
    environment{
        AWS_ACCESS_KEY_ID=credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY=credentials('jenkins-aws-secret-access-key')
        AWS_REGION= "us-east-1"
    }
    stages{
        stage("Checkout"){
            steps{
                echo "========Checkout Github repo========"
                git branch: 'main', url: 'https://github.com/abdelrhman-hamdy/Database-migration-1.git'
            }}
        stage("Pre-work"){
            steps{
                echo "========Deploy pre-work Infrastructure========"
                withCredentials([sshUserPrivateKey(credentialsId: 'hamdy_key', keyFileVariable: 'hamdy_key')]) {
                 sh 'cp ${hamdy_key} ./hamdy_key.pem'   
                }
                sh '''
                  terraform init
                  terraform apply  -auto-approve

                '''
                withCredentials([file(credentialsId: 'ansible_password', variable: 'ansibleVaultKeyFile')]) {
                    sh '''
                    cd MongoConfigurationMangement
                    terrafom init 
                    terraform apply  -auto-approve
                    ./AddServerIPtoInventory.sh
                    ansible-playbook -i inventory --private-key ../hamdy_key.pem  main.yml --vault-password-file ${ansibleVaultKeyFile}
                '''
                }
                
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
                }
            }
        }
    

