#!/bin/bash
set -xe

# Update system
apt-get update -y
apt-get upgrade -y

# Java for Jenkins
apt-get install -y fontconfig openjdk-17-jre

# Jenkins repo
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins + useful tools
apt-get update -y
apt-get install -y jenkins git curl unzip

# Install Docker
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Allow Jenkins user to use Docker
usermod -aG docker jenkins

# AWS CLI v2 (simple install)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Enable + start Jenkins
systemctl enable jenkins
systemctl restart jenkins

# Log initial admin password for convenience
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  cat /var/lib/jenkins/secrets/initialAdminPassword \
    | tee /var/log/jenkins-initial-admin-password.log
fi