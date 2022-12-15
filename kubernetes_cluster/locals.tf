locals {
  aks_config = {
    rg_name                   = format("%s-aks-%s-rg", var.azure_config.resource_group_prefix, var.azure_config.region)
    name                      = format("%s-aks-%s-cluster", var.azure_config.resource_group_prefix, var.azure_config.region)
    kubernetes_version        = lookup(var.aks_config, "kubernetes_version", null) == null ? "1.23" : var.aks_config.kubernetes_version
    vm_size                   = lookup(var.aks_config, "vm_size", null) == null ? "Standard_D2as_v5" : var.aks_config.vm_size
    max_nodes                 = lookup(var.aks_config, "max_nodes", null) == null ? 100 : var.aks_config.max_nodes
    min_nodes                 = lookup(var.aks_config, "min_nodes", null) == null ? 10 : var.aks_config.min_nodes
    max_pods                  = lookup(var.aks_config, "max_pods", null) == null ? 200 : var.aks_config.max_pods
    service_cidr              = lookup(var.aks_config, "service_cidr", null) == null ? "172.20.48.0/20" : var.aks_config.service_cidr
    dns_service_ip            = lookup(var.aks_config, "dns_service_ip", null) == null ? "172.20.48.10" : var.aks_config.dns_service_ip
    docker_bridge_cidr        = lookup(var.aks_config, "docker_bridge_cidr", null) == null ? "172.17.0.1/16" : var.aks_config.docker_bridge_cidr
    availability_zones        = lookup(var.aks_config, "availability_zones", null) == null ? [] : var.aks_config.availability_zones
    api_server_authorized_ip_ranges = lookup(var.aks_config, "api_server_authorized_ip_ranges", null) == null ? [] : var.aks_config.api_server_authorized_ip_ranges
    law_enable                = lookup(var.aks_config, "law_enable", null) == null ? false : var.aks_config.law_enable
    sa_enable                 = lookup(var.aks_config, "sa_enable", null) == null ? false : var.aks_config.law_enable
  }
}
