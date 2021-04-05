#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#
# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

resource "random_id" "cluster_name" {
  byte_length = 2
  prefix      = "eks-acc-"


}

resource "aws_vpc" "eks-acc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"                                                = "terraform-eks-acc-node"
    "kubernetes.io/cluster/${random_id.cluster_name.hex}" = "shared"
  }
}

resource "aws_subnet" "eks-acc" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = aws_vpc.eks-acc.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                = "terraform-eks-acc-node"
    "kubernetes.io/cluster/${random_id.cluster_name.hex}" = "shared"
    "kubernetes.io/role/elb"                              = 1
  }
}

resource "aws_internet_gateway" "eks-acc" {
  vpc_id = aws_vpc.eks-acc.id

  tags = {
    Name = "terraform-eks-acc"
  }
}

resource "aws_route_table" "eks-acc" {
  vpc_id = aws_vpc.eks-acc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-acc.id
  }
}

resource "aws_route_table_association" "eks-acc" {
  count = 2

  subnet_id      = aws_subnet.eks-acc[count.index].id
  route_table_id = aws_route_table.eks-acc.id
}
