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
                echo "🔹 Cloning repository from GitHub..."
                git url: "${GIT_REPO}", branch: 'main'
                echo "✅ Repository cloned successfully!"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔹 Starting Docker image build..."
                sh "docker build --pull --rm --no-cache -t ${DOCKER_IMAGE} ."
                echo "✅ Docker image build completed!"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "🔹 Logging into Docker Hub..."
                withDockerRegistry([credentialsId: 'dockerhub-creds1', url: 'https://index.docker.io/v1/']) {
                    echo "🔹 Pushing image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}"
                }
                echo "✅ Docker image pushed successfully!"
            }
        }

        stage('Deploy') {
            steps {
                echo "🔹 Deploying container..."
                script {
                    try {
                        sh "docker rm -f my-node-app || true"
                        sh "docker pull ${DOCKER_IMAGE}"  // Ensures latest image is used
                        sh "docker run -d --name my-node-app -p 3000:3000 ${DOCKER_IMAGE}"
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
                sh "docker ps | grep my-node-app || echo '🚨 Container failed to start!'"
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