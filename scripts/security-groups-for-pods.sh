cd $1

PG_SG=$(terraform -chdir="saas" output -raw sg_rds_access);
EKS_SG=$(terraform -chdir="eks" output -raw cluster_security_group_id);
RDS_ACCESS_ROLE_ARN=$(terraform -chdir="eks" output -raw web_identity_role_arn)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION=$(echo $AWS_DEFAULT_REGION)
ADMIN_DB_ID=$(terraform -chdir="saas" output -raw postgres_instance_id_admin)
USER_DB_ID=$(terraform -chdir="saas" output -raw postgres_instance_id_users)
PROJECT_DB_ID=$(terraform -chdir="saas" output -raw postgres_instance_id_projects)

cd ..

# Print cluster's CNI version
kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2

curl -o ./scripts/gen/aws-k8s-cni.yaml https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.7.9/config/v1.7/aws-k8s-cni.yaml
sed -i "s/us-west-2/$AWS_REGION/g" aws-k8s-cni.yaml
kubectl apply -f aws-k8s-cni.yaml

# Enable the Amazon VPC CNI add-on to manage network interfaces for pods
kubectl set env daemonset aws-node -n kube-system ENABLE_POD_ENI=true

# Print which nodes have aws-k8s-trunk-eni set to true
kubectl get nodes -o wide -l vpc.amazonaws.com/has-trunk-attached=true

# Disable TCP early demux, so that the kubelet can connect to pods on branch network interfaces using TCP.
# (Required if you are using liveness or readiness probes)
kubectl patch daemonset aws-node -n kube-system \
  -p '{"spec": {"template": {"spec": {"initContainers": [{"env":[{"name":"DISABLE_TCP_EARLY_DEMUX","value":"true"}],"name":"aws-vpc-cni-init"}]}}}}'

cat > ./scripts/gen/rds-access-from-pods-policy.json <<EOF
{
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds-db:connect",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:rds-db:$AWS_REGION:$AWS_ACCOUNT_ID:dbuser:$ADMIN_DB_ID/devpie",
          "arn:aws:rds-db:$AWS_REGION:$AWS_ACCOUNT_ID:dbuser:$USER_DB_ID/devpie",
          "arn:aws:rds-db:$AWS_REGION:$AWS_ACCOUNT_ID:dbuser:$PROJECT_DB_ID/devpie",
        ]
      }
    ]
  }
EOF

# Create IAM policy
aws iam create-policy --policy-name AmazonEKS_RDS_Access_Policy --policy-document file://scripts/gen/rds-access-from-pods-policy.json --no-cli-pager

# Attach new IAM policy to the role
aws iam attach-role-policy \
--policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:gen/AmazonEKS_RDS_Access_Policy \
--role-name AmazonEKS_WEB_Identity_Role

# Create service account
cat > ./scripts/gen/service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: $RDS_ACCESS_ROLE_ARN
  labels:
    app: devpie
  name: devpie
EOF

# Deploy an Amazon EKS SecurityGroupPolicy to your cluster.
cat > ./scripts/gen/security-group-policy.yaml <<EOF
apiVersion: vpcresources.k8s.aws/v1beta1
kind: SecurityGroupPolicy
metadata:
  name: devpie
  namespace: default
spec:
  serviceAccountSelector:
    matchLabels:
      app: devpie
  securityGroups:
    groupIds:
      - $POD_SG
      - $EKS_SG
EOF

kubectl apply -f ./scripts/gen/security-group-policy.yaml
