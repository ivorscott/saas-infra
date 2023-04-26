cd $1

RDS_SG=$(terraform -chdir="saas" output -raw sg_rds_access);
EKS_SG=$(terraform -chdir="eks" output -raw cluster_security_group_id);
RDS_ACCESS_ROLE_ARN=$(terraform -chdir="eks" output -raw web_identity_role_arn)

# Print cluster's CNI version
kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2

# Enable the Amazon VPC CNI add-on to manage network interfaces for pods
kubectl set env daemonset aws-node -n kube-system ENABLE_POD_ENI=true

# Print which nodes have aws-k8s-trunk-eni set to true
kubectl get nodes -o wide -l vpc.amazonaws.com/has-trunk-attached=true

# Disable TCP early demux, so that the kubelet can connect to pods on branch network interfaces using TCP.
# (Required if you are using liveness or readiness probes)
kubectl patch daemonset aws-node -n kube-system \
  -p '{"spec": {"template": {"spec": {"initContainers": [{"env":[{"name":"DISABLE_TCP_EARLY_DEMUX","value":"true"}],"name":"aws-vpc-cni-init"}]}}}}'

# Create service account, SecurityGroupPolicy and deploy
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
 annotations:
   eks.amazonaws.com/role-arn: $RDS_ACCESS_ROLE_ARN
 labels:
   app: devpie
 name: devpie
---
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
     - $RDS_SG
     - $EKS_SG
EOF
