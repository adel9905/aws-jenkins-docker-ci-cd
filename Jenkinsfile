pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        TF_DIR     = "infra"
        APP_DIR    = "app"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Checkout Code') {
            steps {
                // Just to show files / structure
                sh 'pwd'
                sh 'ls -R'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-jenkins-creds',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    dir("${TF_DIR}") {
                        sh 'terraform init -input=false'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Extract Terraform Outputs') {
            steps {
                dir("${TF_DIR}") {
                    script {
                        env.JENKINS_PUBLIC_IP = sh(
                            script: 'terraform output -raw jenkins_public_ip',
                            returnStdout: true
                        ).trim()

                        env.APP_URL = sh(
                            script: 'terraform output -raw app_url',
                            returnStdout: true
                        ).trim()

                        // NEW: SNS topic ARN for notifications
                        env.NOTIFY_TOPIC_ARN = sh(
                            script: 'terraform output -raw deploy_notifications_topic_arn',
                            returnStdout: true
                        ).trim()
                    }
                }
                echo "Jenkins public IP: ${env.JENKINS_PUBLIC_IP}"
                echo "App URL:          ${env.APP_URL}"
                echo "SNS Topic ARN:    ${env.NOTIFY_TOPIC_ARN}"
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -t aws-jenkins-demo-app:latest .'
                }
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                  # stop old container if running
                  docker ps -q --filter "name=aws-jenkins-demo-app" | xargs -r docker rm -f

                  # run new container locally on port 3000
                  docker run -d --name aws-jenkins-demo-app -p 3000:3000 aws-jenkins-demo-app:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo "Deploy to EC2 stage – here you can ssh to ${env.JENKINS_PUBLIC_IP} and run Docker remotely."
                    // Example if later you have a separate app EC2:
                    // sh """
                    //   ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/keys/app-ec2-key.pem ubuntu@${env.JENKINS_PUBLIC_IP} \\
                    //   'docker ps -q --filter "name=aws-jenkins-demo-app" | xargs -r docker rm -f && \\
                    //    docker run -d --name aws-jenkins-demo-app -p 3000:3000 <your-ecr-or-docker-image>'
                    // """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful. App running on port 3000'

            // NEW: send SNS email notification after successful deployment
            withCredentials([
                usernamePassword(
                    credentialsId: 'aws-jenkins-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )
            ]) {
                sh """
                  aws sns publish \
                    --region ${AWS_REGION} \
                    --topic-arn "${NOTIFY_TOPIC_ARN}" \
                    --subject "Jenkins deployment succeeded: ${JOB_NAME} #${BUILD_NUMBER}" \
                    --message "Pipeline ${JOB_NAME} build #${BUILD_NUMBER} finished successfully.\\nApp URL: ${APP_URL}\\nJenkins URL: http://${JENKINS_PUBLIC_IP}:8080"
                """
            }
        }
        failure {
            echo 'Pipeline failed – check stage logs.'
        }
    }
}