variable "azure_config" {
  type = object({
    resource_group_prefix = string
    region                = string
  })
}
