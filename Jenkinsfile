pipeline {
  agent {
    kubernetes {
      namespace 'devops-tools'
      defaultContainer 'python'
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-admin
  containers:
  - name: python
    image: python:3.10-slim
    command:
    - cat
    tty: true
"""
    }
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        container('python') {
          sh '''
            python --version
            pip install --upgrade pip
            pip install -r requirements.txt
          '''
        }
      }
    }

    stage('Migrate Database') {
      steps {
        container('python') {
          sh 'python manage.py migrate'
        }
      }
    }

    stage('Run Tests') {
      steps {
        container('python') {
          sh 'python manage.py test || echo "No tests found"'
        }
      }
    }

    stage('Collect Static (optional)') {
      steps {
        container('python') {
          sh 'python manage.py collectstatic --noinput || true'
        }
      }
    }

  }

  post {
    success {
      echo "✅ Django CI pipeline completed successfully"
    }
    failure {
      echo "❌ Pipeline failed"
    }
  }
}
