resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.azure_config.resource_group_prefix}-log-analytics-workspace"
  location            = var.aks_rg.location
  resource_group_name = var.aks_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
