resource "azurerm_resource_group" "vnet_rg" {
  name     = format("%s-network-%s", var.azure_config.resource_group_prefix, var.azure_config.region)
  location = var.azure_config.region
  tags = merge(
    var.base_tags,
    {
      name = format("%s-network-%s", var.azure_config.resource_group_prefix, var.azure_config.region)
    },
  )
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet10-%s", var.azure_config.resource_group_prefix, var.azure_config.region)
  location            = var.azure_config.region
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.vnet_config.address_space
}

resource "azurerm_subnet" "subnet" {
  name                  = var.vnet_config.subnet_name
  resource_group_name   = azurerm_resource_group.vnet_rg.name
  address_prefixes      = var.vnet_config.subnet_prefixes
  virtual_network_name  = azurerm_virtual_network.vnet.name
}
