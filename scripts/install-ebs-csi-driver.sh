#!/bin/bash
# This script automates the deployment of the Amazon EBS CSI driver.

cd $1

CLUSTER_NAME=$(terraform -chdir="eks" output -raw eks_cluster_name)
OIDC_PROVIDER_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION=$(echo $AWS_DEFAULT_REGION)

cd ..

# Teardown the role and policy inorder to recreate them
aws iam detach-role-policy \
--role-name AmazonEKS_EBS_CSI_DriverRole \
--policy-arn arn:aws:iam::554897346438:policy/AmazonEKS_EBS_CSI_Driver_Policy
aws iam delete-policy --policy-arn arn:aws:iam::554897346438:policy/AmazonEKS_EBS_CSI_Driver_Policy
aws iam delete-role --role-name AmazonEKS_EBS_CSI_DriverRole


cat > ./scripts/gen/ebs-iam-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications",
        "ec2:DetachVolume",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOF

# Create an IAM policy named Amazon_EBS_CSI_Driver with permissions for worker nodes to create and modify Amazon EBS volumes.
aws iam create-policy --policy-name AmazonEKS_EBS_CSI_Driver_Policy --policy-document file://scripts/gen/ebs-iam-policy.json --no-cli-pager

# Create the IAM trust policy file
cat > ./scripts/gen/trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$AWS_ACCOUNT_ID:oidc-provider/oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_PROVIDER_ID"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_PROVIDER_ID:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF

# Create an IAM role
aws iam create-role \
--role-name AmazonEKS_EBS_CSI_DriverRole \
--assume-role-policy-document file://scripts/gen/trust-policy.json --no-cli-pager

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
