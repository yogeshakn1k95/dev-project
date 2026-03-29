resource "aws_sns_topic" "alerts" {
  name = "eks-alerts-topic"

  tags = {
    Environment = "dev"
    Project     = "devops-project"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
