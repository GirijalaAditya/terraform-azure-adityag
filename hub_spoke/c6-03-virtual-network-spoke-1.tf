// Virtual Network -  Spoke 1
resource "azurerm_virtual_network" "vnet_spoke_1" {
  name                = "vnet-spoke-1-${module.resource_group_spoke_1.resource_group_location}"
  location            = module.resource_group_spoke_1.resource_group_location
  resource_group_name = module.resource_group_spoke_1.resource_group_name
  address_space       = ["10.100.0.0/20"]
  tags                = local.common_tags
}

// Subnet Workloads - Spoke 1 
resource "azurerm_subnet" "subnet_spoke_1_workloads" {
  name                                          = "snet-workloads"
  address_prefixes                              = ["10.100.1.0/24"]
  virtual_network_name                          = azurerm_virtual_network.vnet_spoke_1.name
  resource_group_name                           = module.resource_group_spoke_1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}
