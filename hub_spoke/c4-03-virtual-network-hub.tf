// Hub Virtual Network
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub-${module.resource_group_network.resource_group_location}"
  location            = module.resource_group_network.resource_group_location
  resource_group_name = module.resource_group_network.resource_group_name
  address_space       = [var.virtual_network_address_space]
  tags                = local.common_tags
}
