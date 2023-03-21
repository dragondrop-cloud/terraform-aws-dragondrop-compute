variable "log_creator_policy_name" {
  description = "Name of the log creator policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}

variable "secret_reader_policy_name" {
  description = "Name of the secret_reader policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}
