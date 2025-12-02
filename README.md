# AWS Jenkins CI/CD Pipeline with Terraform + Docker + EC2 + SNS Notifications

This project implements a full **CI/CD pipeline** on AWS using:

-   **Terraform** → Infrastructure provisioning\
-   **Jenkins** → Continuous Integration / Continuous Deployment\
-   **Docker** → Build and run application containers\
-   **EC2 (Ubuntu 22.04)** → Jenkins host + application runtime\
-   **Node.js / Express** → Simple demo application\
-   **SNS Email Notifications** → Deployment alerts

The purpose of this project is to practice **real DevOps workflows**
including IaC, CI/CD, AWS automation, Docker builds, Terraform, SNS
alerts, and app deployment on EC2.

------------------------------------------------------------------------

## 🚀 Features

-   Provision AWS infrastructure with Terraform\
-   Install Jenkins, Docker, Git, Java, AWS CLI through cloud-init\
-   Jenkins CI/CD pipeline automatically:
    1.  **Checkout SCM**
    2.  **Checkout Code**
    3.  **Terraform Apply**
    4.  **Extract Terraform Outputs**
    5.  **Build Docker Image**
    6.  **Run Docker Container**
    7.  **Deploy to EC2**
    8.  **Send Email Notification (SNS)**\
    9.  **Post Actions**
-   SNS pushes an email automatically on successful deployment\
-   Fully automated, repeatable DevOps workflow

------------------------------------------------------------------------

## 🏗 Architecture Overview

### Terraform provisions:

-   **Default VPC & subnet**\
-   **Security Group:**
    -   Name: `jenkins-adel-sg-v2`
    -   Ports:
        -   22 → SSH\
        -   8080 → Jenkins\
        -   3000 → Node.js app
-   **EC2 Instance (Ubuntu 22.04 -- t3.medium)**
    -   Key pair: `aws-jenkins-key`
    -   30GB gp3 storage
    -   User-data script installs:
        -   Jenkins
        -   Docker + Docker Compose
        -   Git
        -   Java 11
        -   AWS CLI v2

### NEW --- SNS Notification Infrastructure

Terraform creates:

-   SNS topic: `jenkins-deploy-notifications`
-   Email subscription\
-   Output: `deploy_notifications_topic_arn`

Used by Jenkins to send deployment emails.

------------------------------------------------------------------------

## 📦 Project Structure

    aws-jenkins-docker-ci-cd/
    │
    ├── app/
    │   ├── Dockerfile
    │   ├── app.js
    │   └── package.json
    │
    ├── infra/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── terraform.tfvars
    │   ├── notifications.tf
    │   └── user_data_jenkins.sh
    │
    └── Jenkinsfile

------------------------------------------------------------------------

## ⚙️ Terraform Usage

Before running Terraform, create an EC2 Key Pair:

    aws-jenkins-key

Then:

``` bash
cd infra
terraform init
terraform apply -auto-approve
```

Terraform outputs:

-   **Jenkins URL**
-   **App URL**
-   **SNS Topic ARN**
-   **Public EC2 IP**

📩 AWS also sends a **Subscription Confirmation email** --- you must
click **Confirm**.

------------------------------------------------------------------------

## 🔐 Jenkins Credentials Setup

Requires an IAM user with:

-   `AmazonEC2FullAccess`
-   `AmazonSNSFullAccess`
-   `IAMReadOnlyAccess`

Inside Jenkins create credentials:

**ID: `aws-jenkins-creds`**

  Field         Value
  ------------- -------------------------------------
  Kind          Username with password
  Username      AWS Access Key ID
  Password      AWS Secret Access Key
  ID            `aws-jenkins-creds`
  Description   AWS credentials for Terraform + SNS

------------------------------------------------------------------------

## 🤖 Jenkins Pipeline (Jenkinsfile) --- Updated with Notifications

Pipeline performs:

-   Pull code\
-   Apply Terraform\
-   Build Docker app\
-   Run app container\
-   Deploy to EC2\
-   **Send SNS Email Notification**\
-   Print URLs

SNS email contains:

-   App URL\
-   Jenkins URL\
-   Build number\
-   Pipeline name

------------------------------------------------------------------------

## 🌐 Access After Deployment

-   **Jenkins:**\
    `http://<EC2_PUBLIC_IP>:8080`

-   **Node.js App:**\
    `http://<EC2_PUBLIC_IP>:3000`

------------------------------------------------------------------------

## 🎯 Purpose of This Project

This project demonstrates a real DevOps CI/CD pipeline:

-   Infrastructure as Code (Terraform)
-   Jenkins pipelines with real stages
-   Docker containerization
-   Deployment to EC2
-   AWS SNS notifications
-   Secure AWS credential handling

Great practice for DevOps / Cloud / SRE interviews.

------------------------------------------------------------------------

## 📘 Future Improvements

-   Use S3 + DynamoDB Terraform backend\
-   Push Docker images to ECR\
-   Add Application Load Balancer\
-   Add GitHub webhook triggers\
-   Create multi-environment pipelines (dev/stage/prod)

------------------------------------------------------------------------

## 🏁 Conclusion

This repository demonstrates an end-to-end DevOps automation pipeline:

**Terraform → Jenkins → Docker → EC2 → SNS Notifications → Fully
Automated Deployment**
