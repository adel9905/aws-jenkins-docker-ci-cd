#########################
# Networking (default)  #
#########################

resource "aws_default_vpc" "default" {}

data "aws_availability_zones" "available" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

#########################
# Latest Ubuntu 22.04   #
#########################

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#########################
# Security Group        #
#########################

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-adel-sg-v2"
  description = "Security group for Jenkins + demo app"
  vpc_id      = aws_default_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Jenkins UI
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  # Node.js app
  ingress {
    description = "Node app"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-adel-sg"
  }
}

#########################
# Jenkins EC2 instance  #
#########################

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = var.key_name

  user_data = file("${path.module}/user_data_jenkins.sh")

  tags = {
    Name    = "jenkins-ubuntu-server"
    Role    = "jenkins"
    Project = "jenkins-aws-demo"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}
