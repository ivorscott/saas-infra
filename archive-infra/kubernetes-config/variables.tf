variable "eks_node_role_arn" {
  type = list(string)
}

variable "cluster_ca_cert" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "hostname" {
  description = "The application domain name (e.g., example.com)"
  type = string
}

variable "hosted_zone_id" {
  description = "An existing hosted zone id from route53"
  type = string
}

locals {
  mapped_role_format = <<MAPPEDROLE
- rolearn: %s
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
MAPPEDROLE

}
