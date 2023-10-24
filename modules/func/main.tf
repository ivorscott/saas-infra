terraform {
  required_version = ">= 0.15.5, <= 1.4.6"
}

locals {
  binary_path = ".core/pkg/lambda/${var.package_name}/${var.package_name}"
  archive_path = "zip/${var.package_name}.zip"
}

data "aws_caller_identity" "current" {}

// allow lambda service to assume (use) the role with such policy
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// create lambda role, that lambda function can assume (use)
resource "aws_iam_role" "lambda" {
  name               = "AssumeLambdaRole-${var.stage}"
  description        = "Role for lambda to assume lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

data "aws_iam_policy_document" "allow_lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

// create a policy to allow writing into logs and create logs stream
resource "aws_iam_policy" "function_logging_policy" {
  name        = "AllowLambdaLoggingPolicy-${var.stage}"
  description = "Policy for lambda cloudwatch logging"
  policy      = data.aws_iam_policy_document.allow_lambda_logging.json
}

// create a main policy for lambda function
resource "aws_iam_policy" "function_main_policy" {
  name        = "${var.policy_name}-${var.stage}"
  description = var.policy_description
  policy      = var.policy_json
}

// attach logging policy to role
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  role       = aws_iam_role.lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

// attach main policy to role
resource "aws_iam_role_policy_attachment" "lambda_main_policy_attachment" {
  role       = aws_iam_role.lambda.id
  policy_arn = aws_iam_policy.function_main_policy.arn
}

# Build the binary for the lambda function (Uses Sparse checkout)
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
resource "null_resource" "function_binary" {
  provisioner "local-exec" {
    command = <<-EOT
      rm -rf .core || true
      mkdir .core
      cd .core
      git init
      git remote add -f origin https://github.com/devpies/saas-core

      git config core.sparseCheckout true

      echo "pkg/lambda/" >> .git/info/sparse-checkout

      git pull origin main

      cd pkg/lambda/${var.package_name}
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' .
    EOT
  }
}

// zip the binary, as we can use only zip files to AWS lambda
data "archive_file" "function_archive" {
  depends_on = [null_resource.function_binary]

  type        = "zip"
  source_file = local.binary_path
  output_path = local.archive_path
}

// create the lambda function from zip file
resource "aws_lambda_function" "function" {
  function_name = "${var.package_name}func-${var.stage}"
  description   = var.package_description
  role          = aws_iam_role.lambda.arn
  handler       = var.package_name
  memory_size   = 128

  filename         = local.archive_path
  source_code_hash = data.archive_file.function_archive.output_base64sha256

  runtime = "go1.x"
}
