variable "profile" {
  description = "The AWS profile to fetch credentials for."
  type = string
}

variable "region" {
  description = "The AWS region to use."
  default = "eu-central-1"
  type = string
}

variable "stage" {
  description = "The deployment stage."
  default = "local"
  type = string
}

variable "email" {
  description = "The email address associated with the first admin user."
  type = string
}

variable "hostname" {
  description = "The SaaS hostname."
  default = "devpie.local"
  type = string
}