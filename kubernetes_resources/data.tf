# Configure the AKS data source
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_config.name
  resource_group_name = local.aks_config.rg_name
}
