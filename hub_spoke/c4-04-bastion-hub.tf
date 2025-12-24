// Azure Bastion Subnet
resource "azurerm_subnet" "subnet_bastion" {
  name                                          = "AzureBastionSubnet"
  resource_group_name                           = module.resource_group_network.resource_group_name
  address_prefixes                              = [cidrsubnet(var.virtual_network_address_space, 6, 2)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub.name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Bastion 
module "bastion" {
  source              = "../modules/azure-bastion"
  bastion_subnet_id   = azurerm_subnet.subnet_bastion.id
  resource_group_name = module.resource_group_bastion.resource_group_name
  location            = module.resource_group_bastion.resource_group_location
  name                = "bastion"
  sku                 = "Standard"
  tags                = local.common_tags
}