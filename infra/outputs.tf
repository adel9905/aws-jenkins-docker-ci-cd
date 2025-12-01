output "jenkins_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "app_url" {
  description = "URL to access the sample Node.js app (after pipeline deploy)"
  value       = "http://${aws_instance.jenkins.public_ip}:3000"
}
