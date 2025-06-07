pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ligjeronko/my-node-app"
        GIT_REPO = "https://github.com/ligjeronko/Set-Up-a-CICD-Pipeline-for-Node.js-Application.git"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds1"
        LANG = 'en_US.UTF-8'
        LC_ALL = 'en_US.UTF-8'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "🔹 Cloning repository from GitHub..."
                git url: "${GIT_REPO}", branch: 'main'
                echo "✅ Repository cloned successfully!"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔹 Checking if Docker is running inside Jenkins..."
                sh "docker --version || echo '🚨 Docker not found!'"

                echo "🔹 Starting Docker image build..."
                sh """
                    docker build -t ${DOCKER_IMAGE} . 
                    if [ $? -ne 0 ]; then
                        echo '🚨 Docker Build Failed!'
                        exit 1
                    fi
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "🔹 Logging into Docker Hub..."
                withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS_ID}", url: 'https://index.docker.io/v1/']) {
                    echo "🔹 Pushing image to Docker Hub..."
                    sh """
                        docker push ${DOCKER_IMAGE}
                        if [ $? -ne 0 ]; then
                            echo '🚨 Docker Push Failed!'
                            exit 1
                        fi
                    """
                }
                echo "✅ Docker image pushed successfully!"
            }
        }

        stage('Deploy') {
            steps {
                echo "🔹 Deploying container..."
                script {
                    try {
                        sh """
                            docker rm -f my-node-app || true
                            docker pull ${DOCKER_IMAGE}
                            docker run -d --name my-node-app -p 3000:3000 ${DOCKER_IMAGE}
                        """
                        echo "✅ Container deployed successfully!"
                    } catch (Exception e) {
                        echo "🚨 Deployment failed: ${e}"
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔹 Checking if container is running..."
                sh """
                    docker ps | grep my-node-app
                    if [ $? -ne 0 ]; then
                        echo '🚨 Container failed to start!'
                        exit 1
                    fi
                """
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment successful!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}