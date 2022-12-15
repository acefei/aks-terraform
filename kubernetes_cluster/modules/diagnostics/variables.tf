variable "base_tags" {
  type          = map(string)
}

variable "azure_config" {
  type = object({
    resource_group_prefix = string
    region                = string
    diagnostics_retention_period = number
  })
}

variable "aks_cluster_id" {
    type = string
}

variable "aks_sa_id" {
    type = string
}

variable "aks_law_id" {
    type = string
}
