// Azure Bastion Subnet
resource "azurerm_subnet" "subnet_bastion_region2" {
  name                                          = "AzureBastionSubnet"
  resource_group_name                           = module.resource_group_hub_region2.resource_group_name
  address_prefixes                              = [cidrsubnet(var.vnet_hub_region2_address_space, 6, 2)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub_region2.name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Bastion 
module "bastion_region2" {
  source              = "../modules/azure-bastion"
  bastion_subnet_id   = azurerm_subnet.subnet_bastion_region2.id
  location            = module.resource_group_hub_region2.resource_group_location
  resource_group_name = module.resource_group_hub_region2.resource_group_name
  name                = "bastion"
  sku                 = "Standard"
  tags                = local.common_tags
}