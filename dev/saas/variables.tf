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
  default = "dev"
  type = string
}

variable "email" {
  description = "The email address associated with the first admin user."
  type = string
}

variable "hostname" {
  description = "The SaaS hostname."
  type = string
}

variable "rds_instance_type" {
  description = "The RDS instance type."
  type = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type = string
}

variable "database_subnet_group" {
  description = "The VPC database subnet group"
  type = string
}