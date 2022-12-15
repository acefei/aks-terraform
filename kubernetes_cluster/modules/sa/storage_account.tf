resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = true
  numeric = false
  special = false
}

resource "azurerm_storage_account" "aks_audit_sa" {
  name                     = format("%ssa%s", substr(replace(var.azure_config.resource_group_prefix, "-", ""), 0, 18), random_string.suffix.result)
  resource_group_name      = var.aks_rg.name
  location                 = var.aks_rg.location
  account_tier             = "Standard"
  access_tier              = "Cool"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  tags = merge(
    var.base_tags,
    {
      name = format("%ssa%s", substr(replace(var.azure_config.resource_group_prefix, "-", ""), 0, 18), random_string.suffix.result)
    },
  )
}
