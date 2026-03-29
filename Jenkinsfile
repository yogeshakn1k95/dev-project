pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        BACKEND_REPO = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project"
        FRONTEND_REPO = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project-frontend"
        CLUSTER_NAME = "devops-cluster"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yogeshakn1k95/dev-project.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                echo "Building Backend Image"
                docker build -t backend ./app/backend

                echo "Building Frontend Image"
                docker build -t frontend ./app/frontend
                '''
            }
        }

        stage('Tag Images') {
            steps {
                sh '''
                echo "Tagging Backend Image"
                docker tag backend:latest $BACKEND_REPO:latest

                echo "Tagging Frontend Image"
                docker tag frontend:latest $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                    echo "Logging into ECR"
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin \
                    280362093954.dkr.ecr.ap-south-1.amazonaws.com
                    '''
                }
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                echo "Pushing Backend Image"
                docker push $BACKEND_REPO:latest

                echo "Pushing Frontend Image"
                docker push $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Update kubeconfig') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                    echo "Updating kubeconfig"
                    aws eks update-kubeconfig \
                    --region $AWS_REGION \
                    --name $CLUSTER_NAME
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                    echo "Verifying AWS identity"
                    aws sts get-caller-identity

                    echo "Checking cluster connectivity"
                    kubectl get nodes

                    echo "Deploying Kubernetes manifests"
                    kubectl apply \
                    -f k8s/secret-store.yaml \
                    -f k8s/external-secret.yaml \
                    -f k8s/backend-deployment.yaml \
                    -f k8s/backend-service.yaml \
                    -f k8s/frontend-deployment.yaml \
                    -f k8s/frontend-service.yaml \
                    -f k8s/ingress.yaml
                    '''
                }
            }
        }

    }   

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }

}
