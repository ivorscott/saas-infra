variable "eks_cluster_domain" {
  description = "Route53 domain for the cluster."
  type        = string
}

variable "acm_certificate_domain" {
  description = "Route53 certificate domain."
  type        = string
}
variable "profile" {
  description = "The AWS profile to fetch credentials for."
  type = string
}