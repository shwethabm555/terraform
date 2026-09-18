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

        stage('Check Existing AWS Resources') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform'
                ]]) {
                    bat '''
                        echo === IAM CLUSTER ROLE ===
                        aws iam get-role --role-name terraform-assignment-eks-cluster-role --query "Role.Arn" --output text

                        echo === IAM NODE ROLE ===
                        aws iam get-role --role-name terraform-assignment-eks-node-role --query "Role.Arn" --output text

                        echo === NLB ===
                        aws elbv2 describe-load-balancers --names terraform-assignment-nlb --query "LoadBalancers[0].LoadBalancerArn" --output text

                        echo === TARGET GROUP ===
                        aws elbv2 describe-target-groups --names terraform-assignment-web-tg --query "TargetGroups[0].TargetGroupArn" --output text
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform'
                ]]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform'
                ]]) {
                    bat 'terraform plan'
                }
            }
        }

        stage('Import Existing Resources') {
    steps {
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-terraform'
        ]]) {
            bat '''
                terraform import aws_iam_role.eks_cluster terraform-assignment-eks-cluster-role
                terraform import aws_iam_role.eks_node terraform-assignment-eks-node-role
                terraform import aws_lb.nlb arn:aws:elasticloadbalancing:us-east-1:880884391427:loadbalancer/net/terraform-assignment-nlb/28f4af332da87e7d
                terraform import aws_lb_target_group.web arn:aws:elasticloadbalancing:us-east-1:880884391427:targetgroup/terraform-assignment-web-tg/8e091ac1108c3aa3
            '''
        }
    }
}
    }
}