#!/bin/bash
# This script automates Kubernetes secret generation.

# Generate the AWS secrets
kubectl create secret generic aws.secrets \
--from-literal=aws_access_key_id=$(aws configure get aws_access_key_id) \
--from-literal=aws_secret_access_key=$(aws configure get aws_secret_access_key) || true

# Generate the Docker Registry secret
read -p 'Github email: ' githubemail
read -p 'Github username: ' githubusername
githubreadtoken=`cat .ghcr.token`

kubectl create secret docker-registry ghcr-auth \
--docker-server=https://ghcr.io \
--docker-username=$githubusername \
--docker-password=$githubreadtoken \
--docker-email=$githubemail || true

cd dev/saas

## Generate the Cognito secrets
kubectl create secret generic cognito.secrets \
--from-literal=admin_user_pool_id=$(terraform output -raw admin_user_pool_id) \
--from-literal=admin_app_client_id=$(terraform output -raw admin_app_client_id) \
--from-literal=shared_user_pool_id=$(terraform output -raw tenant_user_pool_id) || true

## Generate the Postgres secrets
kubectl create secret generic postgres.secrets \
--from-literal=postgres_username_users=$(terraform output -raw postgres_hostname_users) \
--from-literal=postgres_password_users=$(terraform output -raw postgres_password_users) \
--from-literal=postgres_hostname_users=$(terraform output -raw postgres_hostname_users) \
--from-literal=postgres_username_admin=$(terraform output -raw postgres_hostname_admin) \
--from-literal=postgres_password_admin=$(terraform output -raw postgres_password_admin) \
--from-literal=postgres_hostname_admin=$(terraform output -raw postgres_hostname_admin) \
--from-literal=postgres_username_projects=$(terraform output -raw postgres_hostname_projects) \
--from-literal=postgres_password_projects=$(terraform output -raw postgres_password_projects) \
--from-literal=postgres_hostname_projects=$(terraform output -raw postgres_hostname_projects) || true