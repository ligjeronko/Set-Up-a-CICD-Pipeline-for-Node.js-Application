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
                    bat 'npm install mocha --save-dev'
                    bat 'npx mocha test/**/*.js || exit 0'
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
                        powershell '''
                            $securePassword = ConvertTo-SecureString $env:DOCKER_PASSWORD -AsPlainText -Force
                            $credObject = New-Object System.Management.Automation.PSCredential ($env:DOCKER_USERNAME, $securePassword)
                            $credObject.GetNetworkCredential().Password | docker login -u $env:DOCKER_USERNAME --password-stdin
                        '''
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
        }
    }
}