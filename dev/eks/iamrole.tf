data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "web_identity_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_blueprints.eks_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_blueprints.eks_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks_blueprints.oidc_provider}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "web_identity_role" {
  assume_role_policy = data.aws_iam_policy_document.web_identity_assume_role_policy.json
  name               = "AmazonEKS_WEB_Identity_Role"
}

