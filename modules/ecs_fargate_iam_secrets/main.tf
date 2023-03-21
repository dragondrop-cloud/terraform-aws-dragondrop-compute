module "division_to_provider_secret" {
  source = "../secret"
  name   = "division_to_provider"
}

module "division_cloud_credentials_secret" {
  source = "../secret"
  name   = "division_cloud_credentials"
}

module "providers_secret" {
  source = "../secret"
  name   = "providers_secret"
}

module "terraform_version_secret" {
  source = "../secret"
  name   = "terraform_version"
}

module "workspace_to_directory_secret" {
  source = "../secret"
  name   = "workspace_to_directory"
}

module "migration_history_storage_secret" {
  source = "../secret"
  name   = "migration_history_storage"
}

module "vcs_token_secret" {
  source = "../secret"
  name   = "vcs_token"
}

module "vcs_user_secret" {
  source = "../secret"
  name   = vcs_user
}

module "vcs_repo_secret" {
  source = "../secret"
  name   = vcs_repo
}

module "vcs_system_secret" {
  source = "../secret"
  name   = vcs_system
}

module "vcs_base_branch_secret" {
  source = "../secret"
  name   = vcs_base_branch
}

module "state_backend_secret" {
  source = "../secret"
  name   = "state_backend"
}

module "terraform_cloud_organization_secret" {
  source = "../secret"
  name   = "terraform_cloud_organization"
}

module "terraform_cloud_token_secret" {
  source = "../secret"
  name   = "terraform_cloud_token"
}

module "job_token_secret" {
  source = "../secret"
  name   = "job_token"
}

resource "aws_iam_policy" "log_creator" {
  name   = "dragondrop-${var.log_creator_policy_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.log_creator.json

  tags = {
    origin = "dragondrop-compute-module"
  }
}

resource "aws_iam_policy" "dragondrop_secret_reader" {
  name   = "dragondrop-${var.secret_reader_policy_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.secret_reader.json

  tags = {
    origin = "dragondrop-compute-module"
  }

  depends_on = [data.aws_iam_policy_document.secret_reader]
}

resource "aws_iam_role" "dragondrop_fargate_runner" {
  assume_role_policy    = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  description           = "Role assumed by the AWS Fargate Container."
  force_detach_policies = false
  name                  = "dragondrop-fargate-runner"
  managed_policy_arns   = [aws_iam_policy.log_creator.arn, aws_iam_policy.dragondrop_secret_reader.arn]

  tags = {
    origin = "dragondrop-compute-module"
  }
}
