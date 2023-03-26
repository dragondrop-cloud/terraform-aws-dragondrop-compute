data "aws_iam_policy_document" "log_creator" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "secret_reader" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    effect = "Allow"
    resources = [
      module.division_to_provider_secret.arn,
      module.division_cloud_credentials_secret.arn,
      module.providers_secret.arn,
      module.terraform_version_secret.arn,
      module.workspace_to_directory_secret.arn,
      module.migration_history_storage_secret.arn,
      module.vcs_token_secret.arn,
      module.vcs_user_secret.arn,
      module.vcs_repo_secret.arn,
      module.vcs_system_secret.arn,
      module.vcs_base_branch_secret.arn,
      module.state_backend_secret.arn,
      module.terraform_cloud_organization_secret.arn,
      module.terraform_cloud_token_secret.arn,
      module.job_token_secret.arn,
    ]
  }

  depends_on = [
    module.division_to_provider_secret,
    module.division_cloud_credentials_secret,
    module.providers_secret,
    module.terraform_version_secret,
    module.workspace_to_directory_secret,
    module.migration_history_storage_secret,
    module.vcs_token_secret,
    module.vcs_user_secret,
    module.vcs_repo_secret,
    module.vcs_system_secret,
    module.vcs_base_branch_secret,
    module.state_backend_secret,
    module.terraform_cloud_organization_secret,
    module.terraform_cloud_token_secret,
    module.job_token_secret
  ]
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "fargate_runner_pass_role" {
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    effect    = "Allow"
    resources = [aws_iam_role.dragondrop_fargate_runner]
  }

  depends_on = [aws_iam_role.dragondrop_fargate_runner]
}
