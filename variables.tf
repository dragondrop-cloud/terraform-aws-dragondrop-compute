variable "region" {
  description = "AWS region into which resources will be deployed."
  type        = string
}

# TODO: Update this to a public ecr path, otherwise might not work?
variable "dragondrop_engine_container_path" {
  description = "Path to the dragondrop engine container used in the ECS Fargate job."
  type        = string
  default     = "us-east4-docker.pkg.dev/dragondrop-prod/dragondrop-engine/engine:latest"
}

variable "https_trigger_containerized_lambda_name" {
  description = "Name of the https trigger containerized lambda that will trigger the dragondrop 'engine' hosted in an ECS Fargate task."
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account with exclusively ECS Task invocation privileges that serves as the service account for compute created by the module."
  type        = string
}

variable "task_cpu_count" {
  description = "Number of vCPU units that the drift mitigation task should run on."
  type        = number
}

variable "task_memory" {
  description = "Amount of compute memory that the drift mitigation task should run on."
  type        = number
}
