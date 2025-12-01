# Jenkins + Docker + Terraform on AWS (Ubuntu EC2)

This project provisions an **Ubuntu t3.medium EC2 instance** using **Terraform**, installs **Jenkins + Docker**, and defines a **Jenkins pipeline** that builds and runs a simple Node.js app in a Docker container on the same host.

## Tech stack

- AWS EC2 (Ubuntu 22.04, t3.medium)
- Terraform (IaC)
- Jenkins (CI/CD)
- Docker
- Node.js / Express

## Architecture

- Terraform creates:
  - Default VPC + subnet (using AWS defaults)
  - Security group opening ports:
    - 22 (SSH)
    - 8080 (Jenkins UI)
    - 3000 (Node.js app)
  - EC2 instance with user-data script that installs:
    - Jenkins
    - Docker
    - Git
    - AWS CLI v2

- Jenkins pipeline (`Jenkinsfile`) steps:
  1. Checkout repository
  2. Build Docker image from `app/Dockerfile`
  3. Run container, replacing any previous one

## Usage

### 1. Terraform apply

Create an EC2 key pair in AWS Console (e.g. `jenkins-key`) and save the `.pem` file locally.

Then:

```bash
cd infra

terraform init

terraform plan -var="key_name=jenkins-key"

terraform apply -var="key_name=jenkins-key" -auto-approve