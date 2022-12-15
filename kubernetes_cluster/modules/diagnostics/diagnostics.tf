
#ENABLE AZURE MONITOR LOG DIAGNOSTICS FOR AKS - COLD STORAGE
resource "azurerm_monitor_diagnostic_setting" "aks_audit_sa" {
  count = var.aks_sa_id ? 1 : 0

  lifecycle {
    ignore_changes = [target_resource_id]
  }
  name               = format("%s-audit-sa", var.azure_config.resource_group_prefix)

  storage_account_id = var.aks_sa_id
  target_resource_id = var.aks_cluster_id

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      days    = var.azure_config.diagnostics_retention_period
      enabled = true
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    retention_policy {
      days    = var.azure_config.diagnostics_retention_period
      enabled = true
    }
  }
}

#ENABLE AZURE MONITOR LOG DIAGNOSTICS FOR AKS - LWA
resource "azurerm_monitor_diagnostic_setting" "aks_audit_law" {
  count = var.aks_law_id ? 1 : 0

  lifecycle {
    ignore_changes = [target_resource_id]
  }
  name               = format("%s-audit-law", var.azure_config.resource_group_prefix)

  log_analytics_workspace_id = var.aks_law_id
  target_resource_id = var.aks_cluster_id

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      days    = var.azure_config.diagnostics_retention_period
      enabled = true
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    retention_policy {
      days    = var.azure_config.diagnostics_retention_period
      enabled = true
    }
  }
}
