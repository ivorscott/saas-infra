# =============================================
# Reqquired Variables
# =============================================

variable "hostname" {
  description = "The application domain name (e.g., example.com)"
  type = string
}

variable "hosted_zone_id" {
  description = "An existing hosted zone id from route53"
  type = string
}

# =============================================
# Variables with Defaults
# =============================================

variable "region" {
  default = "eu-central-1"
  type    = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.18"
}

variable "workers_count" {
  default = 2
}

variable "workers_type" {
  type    = string
  default = "t2.medium"
}
