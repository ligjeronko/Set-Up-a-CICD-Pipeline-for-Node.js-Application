pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ronornon/my-node-app"
        GIT_REPO = "https://github.com/ligjeronko/Set-Up-a-CICD-Pipeline-for-Node.js-Application.git"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${GIT_REPO}", branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -p 3000:3000 ${DOCKER_IMAGE}'
            }
        }
    }
}