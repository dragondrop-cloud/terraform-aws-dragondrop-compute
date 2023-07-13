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
      module.api_path_secret.arn,
      module.division_cloud_credentials_secret.arn,
      module.vcs_token_secret.arn,
      module.terraform_cloud_token_secret.arn,
      module.org_token_secret.arn,
      module.infracost_api_token_secret.arn,
    ]
  }

  depends_on = [
    module.api_path_secret,
    module.division_cloud_credentials_secret,
    module.vcs_token_secret,
    module.terraform_cloud_token_secret,
    module.org_token_secret,
    module.infracost_api_token_secret,
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
    resources = [aws_iam_role.dragondrop_fargate_runner.arn]
  }

  depends_on = [aws_iam_role.dragondrop_fargate_runner]
}
