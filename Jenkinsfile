pipeline {
    agent {
        kubernetes {
            namespace 'devops-tools'
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-admin
  containers:
  - name: python
    image: python:3.10-slim
    command: ['cat']
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
                        pip install -r ./requirements.txt
                    '''
                }
            }
        }

        stage('Migrate DB') {
            steps {
                container('python') {
                    sh '''
                        cd todoApp
                        python manage.py migrate
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                container('python') {
                    sh '''
                        cd todoApp
                        python manage.py test || echo "No tests found"
                    '''
                }
            }
        }

        stage('Run App') {
            steps {
                container('python') {
                    sh '''
                        cd todoApp
                        python manage.py runserver 0.0.0.0:8000 &
                        sleep 5
                    '''
                }
            }
        }
    }
}
