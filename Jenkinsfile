pipeline {
  agent any

  environment {
    ECR_URL = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project"
    AWS_REGION = "ap-south-1"
    CLUSTER_NAME = "devops-cluster" // eks cluster name
    K8S_NAMESPACE = "default"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/yogeshakn1k95/dev-project.git'
      }
    }

    stage('Build Images') {
      steps {
        sh 'docker build -t backend ./app/backend'
        sh 'docker build -t frontend ./app/frontend'
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-credentials', 
          usernameVariable: 'AWS_ACCESS_KEY_ID', 
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          sh '''
          echo "Logging in to ECR..."
          aws ecr get-login-password --region $AWS_REGION | \
            docker login --username AWS --password-stdin $ECR_URL

          echo "Pushing backend image..."
          docker tag backend $ECR_URL:backend
          docker push $ECR_URL:backend

          echo "Pushing frontend image..."
          docker tag frontend $ECR_URL:frontend
          docker push $ECR_URL:frontend
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-credentials', 
          usernameVariable: 'AWS_ACCESS_KEY_ID', 
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          sh '''
          echo "Updating kubeconfig for EKS..."
          aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

          echo "Deploying to EKS..."
          kubectl apply -f k8s/ --namespace $K8S_NAMESPACE
          '''
        }
      }
    }

  }

  post {
    failure {
      echo "Pipeline failed! Check logs and fix errors."
    }
    success {
      echo "Pipeline completed successfully."
    }
  }
}
