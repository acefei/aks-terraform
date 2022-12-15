#!/bin/bash
set -eu
deploy_env=${1:-test}
deploy_region=${2:-eastus}
script_path=$(cd `dirname ${BASH_SOURCE[0]}`; pwd)
tfvars_path="${script_path}/environments/${deploy_env}/terraform.tfvars"

main() {
    cat <<EOF
Please input the error content whose format is:
"""
Error: A resource with the ID "/subscriptions/a18aeab3-3188-4258-b5fe-82a51809c850/resourceGroups/test-network-eastus" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_resource_group" for more information.

  with module.vnet.azurerm_resource_group.vnet_rg,
  on modules/vnet/vnet.tf line 1, in resource "azurerm_resource_group" "vnet_rg":
   1: resource "azurerm_resource_group" "vnet_rg" {
"""
Press ctrl-d when done
----------------------
EOF

    local err_msg=$(cat)
    local resource_addr=$(echo $err_msg | perl -ne 'print $1 if /with (module[^,]+)/')
    local resource_id=$(echo $err_msg | perl -ne 'print $1 if /Error: A resource with the ID "([^"]+)/')
    
    echo -e "\n----------------------"
    set -x
    terraform import -var-file=${tfvars_path} ${resource_addr} ${resource_id}
}

main
