#!/bin/bash

set -e

# set the subscription
export ARM_SUBSCRIPTION_ID=
export ARM_ACCESS_KEY=
# set the backend
export BACKEND_RESOURCE_GROUP=
export BACKEND_STORAGE_ACCOUNT=
export BACKEND_STORAGE_CONTAINER=
export BACKEND_KEY=

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}" \
    -reconfigure

terraform $*

# clean up the local environment
rm -rf .terraform
rm -rf .terraform.lock.hcl