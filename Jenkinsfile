pipeline {
    agent any

    environment {
        BACKEND_IMAGE = "harshalmeshram/foodmarket:backend${BUILD_ID}"
        FRONTEND_IMAGE = "harshalmeshram/foodmarket:frontend${BUILD_ID}"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/HarshalMeshram7/FoodMarket.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh """
                    docker build -t $BACKEND_IMAGE ./backend
                    docker build -t $FRONTEND_IMAGE ./frontend
                """
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                sh """
                    docker push $BACKEND_IMAGE
                    docker push $FRONTEND_IMAGE
                """
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                // Replace image placeholders dynamically in docker-compose file
                sh """
                    sed -i 's|BACKEND_IMAGE|$BACKEND_IMAGE|' docker-compose.yml
                    sed -i 's|FRONTEND_IMAGE|$FRONTEND_IMAGE|' docker-compose.yml
                    
                    docker-compose down || true
                    docker-compose up -d
                """
            }
        }
    }
}
