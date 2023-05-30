module "api_path_secret" {
  source               = "../secret"
  name                 = "api_path"
  tags                 = var.tags
  default_secret_value = var.dragondrop_api_path_name
}

module "division_cloud_credentials_secret" {
  source = "../secret"
  name   = "division_cloud_credentials"
  tags   = var.tags
}

module "vcs_token_secret" {
  source = "../secret"
  name   = "vcs_token"
  tags   = var.tags
}

module "terraform_cloud_token_secret" {
  source = "../secret"
  name   = "terraform_cloud_token"
  tags   = var.tags
}

module "job_token_secret" {
  source = "../secret"
  name   = "job_token"
  tags   = var.tags
}

module "infracost_api_token_secret" {
  source = "../secret"
  name   = "infracost_api_token"
  tags   = var.tags
}

resource "aws_iam_policy" "log_creator" {
  name   = "dragondrop-${var.log_creator_policy_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.log_creator.json

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

resource "aws_iam_policy" "dragondrop_secret_reader" {
  name   = "dragondrop-${var.secret_reader_policy_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.secret_reader.json

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )

  depends_on = [data.aws_iam_policy_document.secret_reader]
}

resource "aws_iam_role" "dragondrop_fargate_runner" {
  assume_role_policy    = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  description           = "Role assumed by the AWS Fargate Container."
  force_detach_policies = false
  name                  = "dragondrop-fargate-runner"
  managed_policy_arns   = [aws_iam_policy.log_creator.arn, aws_iam_policy.dragondrop_secret_reader.arn]

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

# Creating the policy to pass aws_iam_role.
resource "aws_iam_policy" "dragondrop_fargate_runner_pass_role" {
  name   = "dragondrop-pass-role-of-fargate-runner"
  path   = "/"
  policy = data.aws_iam_policy_document.fargate_runner_pass_role.json

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )

  depends_on = [data.aws_iam_policy_document.fargate_runner_pass_role]
}
