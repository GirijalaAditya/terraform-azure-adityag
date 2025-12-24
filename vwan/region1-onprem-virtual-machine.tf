// Subnet Workloads 
resource "azurerm_subnet" "subnet_workloads_region1" {
  name                                          = "snet-workloads"
  address_prefixes                              = [cidrsubnet(var.vnet_onprem_address_space_region1, 6, 1)]
  virtual_network_name                          = azurerm_virtual_network.vnet_onprem_region1.name
  resource_group_name                           = module.resource_group_onprem_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Linux VM
module "vm_linux_onprem_region1" {
  source              = "../modules/virtual-machine/linux"
  vm_name             = "vm-lin-${var.region1}"
  location            = module.resource_group_onprem_region1.resource_group_location
  resource_group_name = module.resource_group_onprem_region1.resource_group_name
  vm_subnet_id        = azurerm_subnet.subnet_workloads_region1.id
  tags                = local.common_tags
}
