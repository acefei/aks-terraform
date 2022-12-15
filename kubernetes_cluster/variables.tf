variable "base_tags" {
  type          = map(string)
}

variable "azure_config" {
  type = object({
    diagnostics_retention_period = number
    resource_group_prefix = string
    region                = string
    admin_group_object_ids = list(string)
  })
}

variable "vnet_config" {
  type = object({
    address_space	    = list(string)
    subnet_name		    = string
    subnet_prefixes	    = list(string)
  })
}

variable "aks_config" {
  type = object({})
}
