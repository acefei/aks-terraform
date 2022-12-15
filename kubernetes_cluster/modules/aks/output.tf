output "aks_rg" {
  value = {
      name = azurerm_resource_group.aks_rg.name
      location = azurerm_resource_group.aks_rg.location
  }
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}
