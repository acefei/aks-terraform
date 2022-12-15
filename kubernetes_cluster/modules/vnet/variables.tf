variable "base_tags" {
  type = map(string)
}

variable "azure_config" {
  type = object({
    resource_group_prefix = string
    region                = string
  })
}

variable "vnet_config" {
  type = object({
    address_space	= list(string)
    subnet_name         = string
    subnet_prefixes	= list(string)
  })
}
