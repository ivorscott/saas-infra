variable "profile" {
  description = "The AWS profile to fetch credentials for."
  type = string
}

variable "region" {
  description = "The AWS region to use."
  type = string
}

variable "stage" {
  description = "The deployment stage."
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

variable "cluster_security_group_id" {
  description = "The EKS cluster security group id"
  type = string
}