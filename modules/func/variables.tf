variable "region" {
  description = "The AWS region to use."
  default = "eu-central-1"
  type = string
}

variable "stage" {
  description = "The deployment stage."
  default = "dev"
  type = string
}

variable "package_name" {
  description = "The lambda package name."
  type = string
}

variable "package_description" {
  description = "The lambda package description."
  type = string
}

variable "policy_json" {
  description = "The main lambda policy formatted in json."
  type = string
}

variable "policy_name" {
  description = "The main lambda policy name."
  type = string
}

variable "policy_description" {
  description = "The lambda policy permission description."
  type = string
}