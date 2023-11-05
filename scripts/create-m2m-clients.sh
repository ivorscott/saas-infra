#!/bin/bash
# This script creates a Machine-to-Machine client application.

echo "M2M client application credentials:"
echo
echo "M2M_POOL_ID="$1
echo "M2M_USER="$2
echo "M2M_PASSWORD="$3

# Delete client application identity if it exists
aws cognito-idp admin-delete-user \
  --user-pool-id $1 \
  --username $2 2> /dev/null || true

# Create client application identity
aws cognito-idp admin-create-user \
  --user-pool-id $1 \
  --username $2

aws cognito-idp admin-set-user-password \
  --user-pool-id $1 \
  --username $2 \
  --password $3 \
  --permanent
