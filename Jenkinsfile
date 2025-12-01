pipeline {
    agent any

    environment {
        APP_NAME = "jenkins-aws-adel-app"
        APP_PORT = "3000"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  cd app
                  docker build -t ${APP_NAME}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                  # Stop and remove old container if exists
                  docker ps -q --filter "name=${APP_NAME}" | xargs -r docker rm -f

                  # Run new container
                  docker run -d --name ${APP_NAME} \
                    -p ${APP_PORT}:3000 \
                    -e BUILD_NUMBER=${BUILD_NUMBER} \
                    ${APP_NAME}:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment successful. App running on port ${APP_PORT}"
        }
        failure {
            echo "Build or deployment failed."
        }
    }
}