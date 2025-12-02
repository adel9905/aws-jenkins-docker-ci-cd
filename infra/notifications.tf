# notifications.tf

variable "notification_email" {
  description = "Email address to receive deployment notifications"
  type        = string
  default     = "adeltech9905@gmail.com" # <-- change this to your email
}

resource "aws_sns_topic" "deploy_notifications" {
  name = "jenkins-deploy-notifications"
}

resource "aws_sns_topic_subscription" "deploy_email" {
  topic_arn = aws_sns_topic.deploy_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

output "deploy_notifications_topic_arn" {
  description = "SNS topic ARN for Jenkins deployment notifications"
  value       = aws_sns_topic.deploy_notifications.arn
}
