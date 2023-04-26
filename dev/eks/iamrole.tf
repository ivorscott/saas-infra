data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "web_identity_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_blueprints.eks_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:devpie"]
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
  name               = "AmazonEKS_WEB_Identity_Role"
  assume_role_policy = data.aws_iam_policy_document.web_identity_assume_role_policy.json
}

data "aws_iam_policy_document" "rds_access" {
  statement {
    actions = ["rds-db:connect"]
    effect = "Allow"
    resources = [
      "arn:aws:rds-db:eu-central-1:${data.aws_caller_identity.current.account_id}:dbuser:admin-default/saas_admin",
      "arn:aws:rds-db:eu-central-1:${data.aws_caller_identity.current.account_id}:dbuser:users-default/users",
      "arn:aws:rds-db:eu-central-1:${data.aws_caller_identity.current.account_id}:dbuser:projects-default/projects"
    ]
  }
}

resource "aws_iam_policy" "rds_access_policy" {
  name        = "AmazonEKS_RDS_Access_Policy"
  description = "Amazon EKS RDS access policy for pods"
  policy      = data.aws_iam_policy_document.rds_access.json
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.rds_access_policy.arn
  role       = aws_iam_role.web_identity_role.name
}
