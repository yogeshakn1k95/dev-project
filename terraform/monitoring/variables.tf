variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group Auto Scaling group name"
  type        = string
}
