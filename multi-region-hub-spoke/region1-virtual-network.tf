resource "azurerm_virtual_network" "vnet_hub_region1" {
  name                = "vnet-hub-${var.region1}"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  address_space       = [var.vnet_hub_region1_address_space]
  tags                = local.common_tags
}
