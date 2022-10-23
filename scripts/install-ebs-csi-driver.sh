#!/bin/bash
# This script automates the deployment of the Amazon EBS CSI driver.

cd dev/eks

CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
OIDC_PROVIDER_URL=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION=$(aws configure get region)

# Create an IAM policy named Amazon_EBS_CSI_Driver with permissions for worker nodes to create and modify Amazon EBS volumes.
aws iam create-policy --policy-name AmazonEKS_EBS_CSI_Driver_Policy --policy-document file://ebs-iam-policy.json

# Create the IAM trust policy file
cat << EoF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$AWS_ACCOUNT_ID:oidc-provider/oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_PROVIDER_URL"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_PROVIDER_URL:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
EoF

# Create an IAM role
aws iam create-role \
--role-name AmazonEKS_EBS_CSI_DriverRole \
--assume-role-policy-document file://trust-policy.json

# Attach new IAM policy to the role
aws iam attach-role-policy \
--policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/AmazonEKS_EBS_CSI_Driver_Policy \
--role-name AmazonEKS_EBS_CSI_DriverRole

# Deploy the Amazon EBS CSI driver
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.12"

# Annotate the ebs-csi-controller-sa Kubernetes service account with ARN of the created IAM role
kubectl annotate serviceaccount ebs-csi-controller-sa \
-n kube-system eks.amazonaws.com/role-arn=arn:aws:iam::$AWS_ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole

# Delete driver pods, the pods are automatically redeployed with the IAM permissions from the IAM policy assigned to the role.
kubectl delete pods -n kube-system -l=app=ebs-csi-controller
