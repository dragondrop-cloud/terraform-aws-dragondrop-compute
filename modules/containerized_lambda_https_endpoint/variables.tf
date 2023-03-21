variable "ecs_task_arn" {
  description = "ARN for the dragondrop-created ECS Fargate Task"
  type = string
}

variable "iam_policy_log_creator_arn" {
  description = "ARN for the IAM policy to create logs."
  type = string
}

variable "lambda_role_assume_policy_json" {
  description = "JSON for the Lambda assume role policy."
  type = string
}

variable "security_group_id" {
  description = "Security group for ECS fargate task networking."
  type        = string
}

variable "subnet_id" {
  description = "Subnet within which the ECS Fargate Task is placed."
  type        = string
}
