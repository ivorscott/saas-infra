variable "region" {
  description = "The AWS region."
  default = "eu-central-1"
  type = string
}

variable "hostname" {
  description = "The SaaS hostname."
  default = "example.com"
  type = string
}

variable "stage" {
  description = "The deployment stage."
  type = string
}