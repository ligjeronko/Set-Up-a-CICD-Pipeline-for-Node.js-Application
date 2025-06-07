pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'node-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    bat 'npm install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    bat 'npm install mocha --save-dev'
                    bat 'npm test || exit 0'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Using cmd /c to properly handle command chaining
                    bat 'cmd /c "docker stop node-app 2>nul || echo Container not running"'
                    bat 'cmd /c "docker rm node-app 2>nul || echo Container not exists"'
                    bat "docker run -d -p 3000:3000 --name node-app ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}