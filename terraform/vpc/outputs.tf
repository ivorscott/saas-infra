output "vpc_id" {
  value = aws_vpc.eks-acc.id
}

output "subnets" {
  value = aws_subnet.eks-acc.*.id
}

output "cluster_name" {
  value = random_id.cluster_name.hex
}

