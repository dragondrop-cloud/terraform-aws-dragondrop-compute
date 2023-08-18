variable "dragondrop_api_path_name" {
  description = "dragondrop API path."
  type        = string
}

variable "log_creator_policy_name" {
  description = "Name of the log creator policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}

variable "s3_state_bucket_name" {
  description = "Optional name of the S3 bucket used for storing Terraform state. The ECS Fargate task created by the module will have read access to this bucket."
  type        = string
}

variable "secret_reader_policy_name" {
  description = "Name of the secret_reader policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
