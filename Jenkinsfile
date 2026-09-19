pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('AWS Test') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform'
                ]]) {
                    bat 'aws sts get-caller-identity'
                }
            }
        }

        stage('Stop EKS Nodes') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform'
                ]]) {
                    bat '''
                        aws ec2 stop-instances --instance-ids i-04366987b0a925d21 i-086cac86458c942ae --region us-east-1
                    '''
                }
            }
        }
    }
}