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
      module.nlp_engine_secret.arn,
      module.vcs_token_secret.arn,
      module.terraform_cloud_token_secret.arn,
    ]
  }

  depends_on = [
    module.api_path_secret,
    module.nlp_engine_secret,
    module.vcs_token_secret,
    module.terraform_cloud_token_secret,
  ]
}

data "aws_iam_policy_document" "s3_state_bucket_reader" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
    ]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_state_bucket_name}/*"]
  }
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
