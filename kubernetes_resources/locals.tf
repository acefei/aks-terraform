locals {
  aks_config = {
    rg_name                   = format("%s-aks-%s-rg", var.azure_config.resource_group_prefix, var.azure_config.region)
    name                      = format("%s-aks-%s-cluster", var.azure_config.resource_group_prefix, var.azure_config.region)
  }
 
  traefik_config = {
    api_dns_label             = format("%s", var.azure_config.resource_group_prefix)
  }
}
