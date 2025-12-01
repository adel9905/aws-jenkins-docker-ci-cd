variable "aws_region" {
  description = "AWS region to deploy the Jenkins EC2 instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to SSH into the instance"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH to the instance"
  type        = string
  default     = "0.0.0.0/0" # for demo only – change to your IP for security
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to access Jenkins (8080) and app (3000)"
  type        = string
  default     = "0.0.0.0/0" # for demo only – change to your IP for security
}
