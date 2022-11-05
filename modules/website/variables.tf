variable "region" {
  type        = string
  description = "The AWS region."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "stage" {
  type        = string
  description = "The deployment stage environment."
}

variable "force_delete" {
  description = "Force delete s3 bucket."
  type        = bool
  default = false
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
  default = {}
}