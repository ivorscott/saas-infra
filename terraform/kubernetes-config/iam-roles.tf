locals {
  oidc_url = split("https://", var.cluster_oidc_issuer_url)[1]
}

resource "aws_iam_role" "external_dns" {
  name     = "external-dns"

  assume_role_policy = templatefile("${path.module}/policies/oidc-assume-role-policy.json", {
    OIDC_ARN=aws_iam_openid_connect_provider.cluster.arn,
    OIDC_URL=local.oidc_url,
    NAMESPACE="default",
    SA_NAME="external-dns"
  })

  inline_policy {
    name = "ExternalDNSIAMPolicy"
    policy = file("${path.module}/policies/external-dns-policy.json")
  }

  tags = {
    "ServiceAccountName"      = "external-dns"
    "ServiceAccountNameSpace" = "default"
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name     = "aws-load-balancer-controller"

  assume_role_policy = templatefile("${path.module}/policies/oidc-assume-role-policy.json", {
    OIDC_ARN=aws_iam_openid_connect_provider.cluster.arn,
    OIDC_URL=local.oidc_url,
    NAMESPACE="default",
    SA_NAME="aws-load-balancer-controller"
  })

  inline_policy {
    name = "AWSLoadBalancerControllerIAMPolicy"
    policy = file("${path.module}/policies/aws-load-balancer-controller-policy.json")
  }

  tags = {
    "ServiceAccountName"      = "aws-load-balancer-controller"
    "ServiceAccountNameSpace" = "default"
  }
}