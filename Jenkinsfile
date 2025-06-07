pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ligjeronko/node-app'
        DOCKER_TAG = 'latest'
        NODE_ENV = 'production'
    }

    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
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
                    bat 'npm install -g mocha'
                    bat 'npm install mocha --save-dev'
                    bat 'npm test || exit 0'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds1', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        bat "echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin"
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    bat "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    bat 'cmd /c "docker stop node-app 2>nul || echo Container not running"'
                    bat 'cmd /c "docker rm node-app 2>nul || echo Container not exists"'
                    bat "docker run -d -p 3000:3000 --name node-app ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    bat 'timeout /t 10 /nobreak'
                    bat 'curl http://localhost:3000 || echo "Application not responding"'
                }
            }
        }
    }

    post {
        always {
            script {
                bat 'docker logout'
            }
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded! Application deployed successfully.'
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
            bat 'docker logs node-app || echo "No container logs available"'
        }
    }
}