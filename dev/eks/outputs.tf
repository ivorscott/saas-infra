output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

output "eks_cluster_name" {
  description = "The EKS cluster name"
  value = module.eks_blueprints.eks_cluster_id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block"
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  description = "The VPC ID"
  value = module.vpc.vpc_id
}

output "database_subnet_group" {
  description = "The VPC database subnet group"
  value = module.vpc.database_subnet_group
}

output "cluster_security_group_id" {
  description = "The EKS cluster security group id"
  value = module.eks_blueprints.cluster_security_group_id
}

output "web_identity_role_arn" {
  description = "The web identity based IAM role used by pods"
  value = aws_iam_role.web_identity_role.arn
}