#!/bin/bash
# This script automates Kubernetes secret generation.

# Generate the AWS secrets
echo "Generating AWS secrets..."
kubectl create secret generic aws.secrets \
--from-literal=aws_access_key_id=$(aws configure get aws_access_key_id) \
--from-literal=aws_secret_access_key=$(aws configure get aws_secret_access_key) \
--save-config \
--dry-run=client \
--output=yaml | kubectl apply -f -

# Generate the Docker Registry secret
echo "Generating Docker Registry secret..."
read -p 'Github email: ' githubemail
read -p 'Github username: ' githubusername
githubreadtoken=`cat .ghcr.token`

kubectl create secret docker-registry ghcr-auth \
--docker-server=https://ghcr.io \
--docker-username=$githubusername \
--docker-password=$githubreadtoken \
--docker-email=$githubemail \
--save-config \
--dry-run=client \
--output=yaml | kubectl apply -f -

cd dev/saas

## Generate the Cognito secrets
echo "Generating Cognito secrets..."
kubectl create secret generic cognito.secrets \
--from-literal=admin_user_pool_id=$(terraform output -raw admin_user_pool_id) \
--from-literal=admin_app_client_id=$(terraform output -raw admin_app_client_id) \
--from-literal=shared_user_pool_id=$(terraform output -raw tenant_user_pool_id) \
--save-config \
--dry-run=client \
--output=yaml | kubectl apply -f -

## Generate the Postgres secrets
echo "Generating Postgres secrets..."
kubectl create secret generic postgres.secrets \
--from-literal=postgres_username_users=$(terraform output -raw postgres_username_users) \
--from-literal=postgres_password_users=$(terraform output -raw postgres_password_users) \
--from-literal=postgres_hostname_users=$(terraform output -raw postgres_hostname_users) \
--from-literal=postgres_username_admin=$(terraform output -raw postgres_username_admin) \
--from-literal=postgres_password_admin=$(terraform output -raw postgres_password_admin) \
--from-literal=postgres_hostname_admin=$(terraform output -raw postgres_hostname_admin) \
--from-literal=postgres_username_projects=$(terraform output -raw postgres_username_projects) \
--from-literal=postgres_password_projects=$(terraform output -raw postgres_password_projects) \
--from-literal=postgres_hostname_projects=$(terraform output -raw postgres_hostname_projects) \
--save-config \
--dry-run=client \
--output=yaml | kubectl apply -f -