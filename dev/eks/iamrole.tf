data "tls_certificate" "cert" {
  url = module.eks_blueprints.eks_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates[0].sha1_fingerprint]
  url             = module.eks_blueprints.eks_oidc_issuer_url
}

data "aws_iam_policy_document" "web_identity_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:devpie"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openid.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.openid.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "web_identity_role" {
  assume_role_policy = data.aws_iam_policy_document.web_identity_assume_role_policy.json
  name               = "AmazonEKS_WEB_Identity_Role"
}

