variable "security_group_id" {
  description = "Security group for ECS fargate task networking."
  type        = string
}

variable "subnet_id" {
  description = "Subnet within which the ECS Fargate Task is placed."
  type        = string
}
