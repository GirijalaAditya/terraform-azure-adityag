variable "bastion_virtual_network_address_space" {
  type        = string
  description = "Bastion Virtual Network Address Space"
  default     = "10.0.0.0/24"
}

// Bastion Resource Group
module "resource_group_bastion" {
  source   = "../modules/resource-group"
  name     = "rg-bastion-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}

// Bastion Virtual Network
resource "azurerm_virtual_network" "vnet_bastion" {
  name                = "vnet-bastion-${module.resource_group_network.resource_group_location}"
  location            = module.resource_group_bastion.resource_group_location
  resource_group_name = module.resource_group_bastion.resource_group_name
  address_space       = [var.bastion_virtual_network_address_space]
  tags                = local.common_tags
}

// Azure Bastion Subnet
resource "azurerm_subnet" "subnet_bastion" {
  name                                          = "AzureBastionSubnet"
  resource_group_name                           = module.resource_group_bastion.resource_group_name
  address_prefixes                              = [cidrsubnet(var.bastion_virtual_network_address_space, 2, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_bastion.name
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

// Virtual Hub Connection
resource "azurerm_virtual_hub_connection" "vhub_connection_bastion" {
  name                      = "vhub-connection-${azurerm_virtual_network.vnet_bastion.name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub_region1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet_bastion.id
  internet_security_enabled = false
}