pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ronornon/my-node-app"
        GIT_REPO = "https://github.com/ligjeronko/Set-Up-a-CICD-Pipeline-for-Node.js-Application.git"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${GIT_REPO}", branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "docker rm -f my-node-app || true"
                sh "docker run -d --name my-node-app -p 3000:3000 ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        success {
            echo '🎉 Deployment successful!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs.'
        }
    }
}