variable "base_tags" {
  type          = map(string)
}

variable "azure_config" {
  type = object({
    resource_group_prefix = string
    region                = string
  })
}

variable "aks_rg" {
  type          = map(string)
}
