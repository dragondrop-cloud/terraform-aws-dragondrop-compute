output "lambda_role_assume_policy_json" {
  description = "JSON for the Lambda assume role policy."
  value       = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

output "role_ecs_fargate_task_arn" {
  description = "ARN for the IAM role used by the ECS Fargate Task."
  value       = aws_iam_role.dragondrop_fargate_runner.arn
}

output "policy_log_creator_arn" {
  description = "ARN for the IAM policy to create logs."
  value       = aws_iam_policy.log_creator.arn
}
