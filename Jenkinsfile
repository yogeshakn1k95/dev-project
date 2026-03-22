pipeline {
  agent any

  environment {
    ECR_URL = "280362093954.dkr.ecr.ap-south-1.amazonaws.com/dev-project"
  }

  stages {

    stage('Checkout') {
      steps {
        // Explicitly specify the default branch 'main'
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
        sh '''
        aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $ECR_URL

        docker tag backend $ECR_URL/backend:latest
        docker push $ECR_URL/backend:latest

        docker tag frontend $ECR_URL/frontend:latest
        docker push $ECR_URL/frontend:latest
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f k8s/'
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
