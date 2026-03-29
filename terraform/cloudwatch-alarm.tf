resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name          = "eks-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 60
  statistic   = "Average"

  threshold = 70

  alarm_description = "Alert when CPU usage exceeds 70%"

  dimensions = {
    AutoScalingGroupName = var.node_group_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]
}
