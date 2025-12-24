# Network Resource Group
module "resource_group_network" {
  source   = "../modules/resource-group"
  name     = "rg-network"
  location = var.region1
  tags     = local.common_tags
}

// Virtual WAN
resource "azurerm_virtual_wan" "vwan" {
  name                           = "vwan"
  resource_group_name            = module.resource_group_network.resource_group_name
  location                       = module.resource_group_network.resource_group_location
  type                           = "Standard"
  allow_branch_to_branch_traffic = true
  disable_vpn_encryption         = true
  tags                           = local.common_tags
}
