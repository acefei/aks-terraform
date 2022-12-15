resource "azurerm_resource_group" "aks_rg" {
  name     = var.aks_config.rg_name
  location = var.azure_config.region
  tags     = var.base_tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.aks_config.name
  location                  = var.azure_config.region
  resource_group_name       = azurerm_resource_group.aks_rg.name
  dns_prefix                = var.aks_config.name
  kubernetes_version        = var.aks_config.kubernetes_version

  # The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster.
  node_resource_group       = format("%s-aks-%s-node-rg", var.azure_config.resource_group_prefix, var.azure_config.region)

  default_node_pool {
    name                = "nodepool0"
    enable_auto_scaling = true
    vm_size             = var.aks_config.vm_size
    min_count           = var.aks_config.min_nodes
    max_count           = var.aks_config.max_nodes
    max_pods            = var.aks_config.max_pods
    zones               = var.aks_config.availability_zones
    vnet_subnet_id      = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"

    # CIDR definine the IP subnet to use for AKS services.  This CIDR must be unique
    # across all the Citrix network, different from the subnet defined in
    # subnet_name / subnet_vnet_name, and NOT defined as an Azure subnet.
    # The script will fail if there is an Azure subnet defined that matches
    # this subnet.
    service_cidr       = var.aks_config.service_cidr

    # IP address of the DNS service to use within the AKS cluster.  This should
    # be the 10th IP defined in the service_cidr subnet
    dns_service_ip     = var.aks_config.dns_service_ip

    docker_bridge_cidr = var.aks_config.docker_bridge_cidr
  }

  # A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster.
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.azure_config.admin_group_object_ids
  }

  # Set AKS authorized IP list to restrict access to the API server
  api_server_authorized_ip_ranges = var.aks_config.api_server_authorized_ip_ranges

  dynamic "oms_agent" {
    for_each = var.aks_config.law_enable ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  tags = merge(
    var.base_tags,
    {
      name = var.aks_config.name
    },
  )
}
