output "lambda_role_assume_policy_json" {
  description = "JSON for the Lambda assume role policy."
  value       = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

output "role_ecs_fargate_task_arn" {
  description = "ARN for the IAM role used by the ECS Fargate Task."
  value       = aws_iam_role.dragondrop_fargate_runner.arn
}

output "policy_pass_role_ecs_fargate_task_arn" {
  description = "ARN for the IAM policy to pass the role from the ECS Fargate Task."
  value       = aws_iam_policy.dragondrop_fargate_runner_pass_role.arn
}

output "policy_log_creator_arn" {
  description = "ARN for the IAM policy to create logs."
  value       = aws_iam_policy.log_creator.arn
}

# Secrets ARN Output
output "api_path_secret_arn" {
  value = module.api_path_secret.arn
}

output "division_cloud_credentials_secret_arn" {
  value = module.division_cloud_credentials_secret.arn
}

output "vcs_token_secret_arn" {
  value = module.vcs_token_secret.arn
}

output "terraform_cloud_token_secret_arn" {
  value = module.terraform_cloud_token_secret.arn
}

output "org_token_secret_arn" {
  value = module.org_token_secret.arn
}

output "infracost_api_token_secret_arn" {
  value = module.infracost_api_token_secret.arn
}
