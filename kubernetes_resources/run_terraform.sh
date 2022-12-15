#!/bin/bash
set -eux

deploy_env=${1:-test}
deploy_region=${2:-eastus}
script_path=$(cd `dirname ${BASH_SOURCE[0]}`; pwd)
tfvars_path="${script_path}/environments/${deploy_env}/terraform.tfvars"
backend_path="${script_path}/environments/${deploy_env}/${deploy_region}/backend.tf"

prepare() {
    # ensure service principal credentials in environment variables, ref: https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#specify-service-principal-credentials-in-environment-variables
#    export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
#    export ARM_TENANT_ID="<azure_subscription_tenant_id>"
#    export ARM_CLIENT_ID="<service_principal_appid>"
#    export ARM_CLIENT_SECRET="<service_principal_password>"
#    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

    ls $tfvars_path $backend_path
    sed -i "s/@REGION@/${deploy_region}/g" ${tfvars_path}
}

main() {
    prepare
    export PS4="---> Running terraform command:\n"
    terraform -version
    terraform init -no-color -backend-config=${backend_path}
    terraform plan -no-color -var-file=${tfvars_path}
    if [ "${DRY_RUN:-true}" != "true" ];then
        terraform apply -no-color -auto-approve -var-file=${tfvars_path}
    fi
}

main
