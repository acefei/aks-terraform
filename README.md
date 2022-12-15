# aks-terraform
Provision Azure AKS Cluster using Terraform with Azure Vnet, Azure Container Registry, Core charts(kured)

## How does terraform work
1. Create Resource group, Storage Account and Container for terraform backend store, please use the name defined in environments/<region>
2. Update backend.tf for subscription_id and tenant_id and terraform var
3. `make deveops-box` enter devops container
4. Specify service principal credentials in environment variables
```
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```
5. `bash run_terraform.sh <deploy_env> <deploy_region>`, Note: run `./import_existing_resource.sh` if raising existing resource error.

## Terraform Structure
- main.tf: resources and data source configuration.
- provider.tf: provider dependencies (a terraform configuration block with a nested required providers block).
- output.tf: defining what should be reported after the Terraform plan has been executed.
- backend.tf: add this file to store the Terraform State in some backend.
- variables.tf: the variable definitions, any variables that are not given a default value will become required arguments.
- xxx.tfvars: set the value to the variables defined in variables.tf file, just like input variables.
- locals.tf: given function calls not allowed in tfvars, we can create local.tf to achieve it.

## Terraform Tricks
- Define the redundant variable.tf both on root path and module path, even they are identical.
```
├── README.md
├── module
│   ├── module.tf
│   └── variables.tf     
├── main.tf
└── variables.tf
```
if missing `variable.tf`, it would raise `Error: Reference to undeclared input variable`
if missing `module/variable.tf`, it would raise `Error: Unsupported argument`

Generally, you might follow the steps below to add variable:
1. add variable definition in environments/<env>/terraform.tfvars
2. add variable declaration in root variables.tf
3. use variable as input in main.tf
4. add variable declaration in module variables.tf
5. use variable in module.tf

Ref: https://github.com/hashicorp/terraform/issues/21547

- The argument "xxx" is required, but no definition was found.
when "xxx" declear in variable.tf, that means including "xxx" as input variable in the main.tf when calling a module. it would look like that:
```
module "m1" {
    source = "./modules/m1"
    xxx    = "xxx_object"
}
```

Ref: https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables

- Warning: Missing backend configuration -backend-config was used without a "backend" block in the configuration.
This warning raised when running `terraform init -no-color -backend-config=xxx`, since we'd like to store remote state on azure storage with various backen-config for different region. the following steps should be taken to fix this warning.
1. put `backend "azurerm" {}` within `terraform {}` block.
2. `subscription_id` and `tenant_id` are required arguments both in backend.tf and provider "azurerm" block (this can also be sourced from the relevant Environment Variable, plase find details in [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)), otherwise, it would raise an Error when running `terraform init` or `terraform plan`, something like:
```
Error: building AzureRM Client: 1 error occurred:
        * A Subscription ID must be configured when authenticating as a Service Principal using a Client Secret.
        ...
```
For the details, please find backend.tf and providers.tf

- Error: Backend configuration changed
In my case it went away after I deleted `.terraform` directory in the local copy of the repository and run `terragrunt plan` again.

## Import an Existing Azure Resource in Terraform
1. run `terraform apply -no-color -auto-approve -var-file=${tfvars_path}`, it would raise an error, something like: 
```
Error: A resource with the ID "/subscriptions/a18aeab3-3188-4258-b5fe-82a51809c850/resourceGroups/centaurus-test-network-eastus
" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource docum
entation for "azurerm_resource_group" for more information.

  with module.vnet.azurerm_resource_group.vnet_rg,
  on modules/vnet/vnet.tf line 1, in resource "azurerm_resource_group" "vnet_rg":
   1: resource "azurerm_resource_group" "vnet_rg" {
```
2. run `terraform [global options] import [options] ADDR ID`, ADD is module.vnet.azurerm_resource_group.vnet_rg and ID is "/subscriptions/a18aeab3-3188-4258-b5fe-82a51809c850/resourceGroups/centaurus-test-network". Alternative, run the script `import_existing_resource.sh` in terraform path.
