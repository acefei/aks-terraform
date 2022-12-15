variable "base_tags" {
  type          = map(string)
}

variable "azure_config" {
  type = object({
    resource_group_prefix = string
    region                = string
    admin_group_object_ids = list(string)
  })
}

variable "aks_config" {
  type = object({
    name             = string
    rg_name             = string
    vm_size 	    	= string
    max_nodes       	= number
    min_nodes       	= number
    max_pods        	= number
    kubernetes_version	= string
    law_enable          = bool
    sa_enable           = bool
    availability_zones  = list(string)
    api_server_authorized_ip_ranges = list(string)
    service_cidr        = string
    dns_service_ip      = string
    docker_bridge_cidr  = string
  })
}

variable "subnet_id" {}
variable "log_analytics_workspace_id" {}
