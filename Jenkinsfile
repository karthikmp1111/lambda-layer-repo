pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/karthikmp1111/lambda-layer-repo.git'
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
                ]) {
                    sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY
                    aws configure set aws_secret_access_key $AWS_SECRET_KEY
                    aws configure set region $AWS_REGION
                    '''
                }
            }
        }

        stage('Build Lambda Layer') {
            steps {
                script {
                    dir('lambda-layer') {
                        sh '''
                        set -e
                        chmod +x build_layer.sh
                        ./build_layer.sh
                        '''
                    }
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('lambda-layer/terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Store Layer ARN') {
            steps {
                script {
                    def layerArn = sh(script: '''
                        terraform output -raw lambda_layer_arn
                    ''', returnStdout: true).trim()
                    
                    echo "✅ Lambda Layer ARN: ${layerArn}"
                    env.LAYER_ARN = layerArn
                }
            }
        }
    }
}
