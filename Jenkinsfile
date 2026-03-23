pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_URL = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project"
        CLUSTER_NAME = "devops-cluster"
    }

    stages {

        stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/yogeshakn1k95/dev-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t backend ./app/backend'
            }
        }

        stage('Tag Image') {
            steps {
                sh 'docker tag backend $ECR_URL/backend:latest'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_URL
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh 'docker push $ECR_URL/backend:latest'
            }
        }

        stage('Update kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                --region $AWS_REGION \
                --name $CLUSTER_NAME
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                kubectl apply -f k8s/backend-deployment.yaml
                kubectl apply -f k8s/backend-service.yaml
                '''
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

// pipeline {
//   agent any

//   environment {
//     ECR_URL = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project"
//     AWS_REGION = "ap-south-1"
//     CLUSTER_NAME = "devops-cluster"
//     K8S_NAMESPACE = "default"
//   }

//   stages {

//     stage('Checkout') {
//       steps {
//         git branch: 'main', url: 'https://github.com/yogeshakn1k95/dev-project.git'
//       }
//     }

//     stage('Build Images') {
//       steps {
//         sh 'docker build -t backend ./app/backend'
//         sh 'docker build -t frontend ./app/frontend'
//       }
//     }

//     stage('Push to ECR') {
//       steps {
//         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
//           credentialsId: 'aws-credentials'
//         ]]) {
//           sh '''
//           echo "DEBUG: AWS Identity"
//           aws sts get-caller-identity

//           echo "Logging in to ECR..."
//           aws ecr get-login-password --region $AWS_REGION | \
//             docker login --username AWS --password-stdin $ECR_URL

//           echo "Pushing backend image..."
//           docker tag backend $ECR_URL:backend
//           docker push $ECR_URL:backend

//           echo "Pushing frontend image..."
//           docker tag frontend $ECR_URL:frontend
//           docker push $ECR_URL:frontend
//           '''
//         }
//       }
//     }

//     stage('Deploy to EKS') {
//       steps {
//         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
//           credentialsId: 'aws-credentials'
//         ]]) {
//           sh '''
//           echo "DEBUG: AWS Identity"
//           aws sts get-caller-identity

//           echo "Updating kubeconfig for EKS..."
//           aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

//           echo "Deploying to EKS..."
//           kubectl apply -f k8s/ --namespace $K8S_NAMESPACE
//           '''
//         }
//       }
//     }

//   }

//   post {
//     failure {
//       echo "Pipeline failed! Check logs and fix errors."
//     }
//     success {
//       echo "Pipeline completed successfully."
//     }
//   }
// }
