pipeline {
    agent any

    environment {
        IMAGE_NAME = "harshalmeshram/foodmarket:${BUILD_ID}"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/HarshalMeshram7/FoodMarket.git'
            }
    }


        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Remove Local Image (simulate pull step)') {
            steps {
                sh 'docker rmi $IMAGE_NAME'
            }
        }

        stage('Pull and Run Container') {
            steps {
                sh '''
                    docker pull $IMAGE_NAME
                    docker stop foodmarket || true && docker rm foodmarket || true
                    docker run -d --name foodmarket -p 5002:5002 $IMAGE_NAME
                '''
            }
        }
    }
}
