output "ecs_task_arn" {
  description = "ARN for the ECS Fargate Task."
  value       = aws_ecs_task_definition.dragondrop_drift_task.arn
}

output "log_creator_policy_arn" {
  description = "ARN for the IAM policy to create logs."
  value       = module.ecs_fargate_iam_secrets.policy_log_creator_arn
}

output "lambda_role_assume_policy_json" {
  description = "JSON for the Lambda assume role policy."
  value       = module.ecs_fargate_iam_secrets.lambda_role_assume_policy_json
}
