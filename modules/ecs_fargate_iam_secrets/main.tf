module "api_path_secret" {
  source               = "../secret"
  name                 = "api_path"
  tags                 = var.tags
  default_secret_value = var.dragondrop_api_path_name
}

module "nlp_engine_secret" {
  source               = "../secret"
  name                 = "nlp_engine_api"
  tags                 = var.tags
  default_secret_value = var.nlp_engine_api
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

resource "aws_iam_policy" "s3_state_bucket_reader" {
  name   = "dragondrop-s3-bucket-reader"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_state_bucket_reader.json

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )

  depends_on = [data.aws_iam_policy_document.s3_state_bucket_reader]
}

resource "aws_iam_role" "dragondrop_fargate_runner" {
  assume_role_policy    = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  description           = "Role assumed by the AWS Fargate Container."
  force_detach_policies = false
  name                  = "dragondrop-fargate-runner"
  # If an s3 state backend bucket was specified, add the corresponding policy document, if not, leave it off.
  managed_policy_arns = var.s3_state_bucket_name == "NONE" ? [aws_iam_policy.log_creator.arn, aws_iam_policy.dragondrop_secret_reader.arn, "arn:aws:iam::aws:policy/ReadOnlyAccess"] : [aws_iam_policy.log_creator.arn, aws_iam_policy.dragondrop_secret_reader.arn, aws_iam_policy.s3_state_bucket_reader.arn, "arn:aws:iam::aws:policy/ReadOnlyAccess"]

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
