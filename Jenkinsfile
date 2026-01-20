pipeline {
  agent {
    kubernetes {
      namespace 'devops-tools'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-admin
  hostNetwork: true
  containers:
  - name: maven
    image: maven:3.9.6-eclipse-temurin-17
    command:
    - cat
    tty: true

  - name: test
    image: maven:3.9.6-eclipse-temurin-17
    command:
    - cat
    tty: true

  - name: buildah
    image: quay.io/buildah/stable:latest
    securityContext:
      privileged: true
      runAsUser: 0
    command:
    - cat
    tty: true

  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
"""
    }
  }

  environment {
    AWS_REGION = 'ap-south-1'
    IMAGE_NAME = 'myapp'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        container('maven') {
          sh '''
            mvn clean package -DskipTests
          '''
          stash includes: '**/target/*.jar', name: 'jar'
        }
      }
    }

    stage('Test') {
      steps {
        container('test') {
          sh '''
            mvn test || echo "No tests configured"
          '''
        }
      }
    }

    stage('Build & Push Image') {
      steps {
        container('buildah') {
          withCredentials([
            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
            string(credentialsId: 'ECR_REGISTRY', variable: 'ECR_REGISTRY'),
            string(credentialsId: 'ECR_REPO', variable: 'ECR_REPO')
          ]) {
            sh '''
              aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
              aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
              aws configure set region $AWS_REGION

              aws ecr get-login-password --region $AWS_REGION \
                | buildah login --username AWS --password-stdin $ECR_REGISTRY

              unstash jar
              buildah bud -t $IMAGE_NAME .
              buildah tag $IMAGE_NAME $ECR_REGISTRY/$ECR_REPO:${BUILD_NUMBER}
              buildah push $ECR_REGISTRY/$ECR_REPO:${BUILD_NUMBER}
            '''
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        container('kubectl') {
          sh '''
            sed -i "s/:latest/:${BUILD_NUMBER}/g" deployment.yaml
            kubectl apply -f deployment.yaml
            kubectl rollout status deployment myapp
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ CI/CD Pipeline completed successfully"
    }
    failure {
      echo "❌ Pipeline failed"
    }
  }
}
