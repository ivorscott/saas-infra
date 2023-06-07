cd $1

POD_SG=$(terraform -chdir="saas" output -raw sg_rds_access);

# Print cluster's CNI version
kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2

# Enable the Amazon VPC CNI add-on to manage network interfaces for pods
kubectl set env daemonset aws-node -n kube-system ENABLE_POD_ENI=true
kubectl -n kube-system rollout status ds aws-node

# Print which nodes have aws-k8s-trunk-eni set to true
kubectl get nodes -o wide -l vpc.amazonaws.com/has-trunk-attached=true

# Disable TCP early demux, so that the kubelet can connect to pods on branch network interfaces using TCP.
# (Required if you are using liveness or readiness probes)
kubectl patch daemonset aws-node -n kube-system \
  -p '{"spec": {"template": {"spec": {"initContainers": [{"env":[{"name":"DISABLE_TCP_EARLY_DEMUX","value":"true"}],"name":"aws-vpc-cni-init"}]}}}}'

# Deploy SecurityGroupPolicy
kubectl apply -f - <<EOF
apiVersion: vpcresources.k8s.aws/v1beta1
kind: SecurityGroupPolicy
metadata:
 name: allow-rds-access
spec:
 podSelector:
   matchLabels:
     pod: requires-rds
 securityGroups:
   groupIds:
     - $POD_SG
EOF

kubectl describe securitygrouppolicy