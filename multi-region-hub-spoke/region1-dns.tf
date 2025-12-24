// Resource Group
module "resource_group_dns_region1" {
  source   = "../modules/resource-group"
  name     = "rg-dns-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}

// Virtual Network -  DNS
resource "azurerm_virtual_network" "vnet_dns_region1" {
  name                = "vnet-dns-${module.resource_group_dns_region1.resource_group_location}"
  location            = module.resource_group_dns_region1.resource_group_location
  resource_group_name = module.resource_group_dns_region1.resource_group_name
  address_space       = ["10.100.0.0/24"]
  tags                = local.common_tags
}

// Subnet Workloads - Domain Controller
resource "azurerm_subnet" "subnet_dc_region1" {
  name                                          = "snet-dc"
  address_prefixes                              = ["10.100.0.0/26"]
  virtual_network_name                          = azurerm_virtual_network.vnet_dns_region1.name
  resource_group_name                           = module.resource_group_dns_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Subnet Workloads - Domain Forwarder
resource "azurerm_subnet" "subnet_dns_forwarder_region1" {
  name                                          = "snet-dns-forwarder"
  address_prefixes                              = ["10.100.0.64/26"]
  virtual_network_name                          = azurerm_virtual_network.vnet_dns_region1.name
  resource_group_name                           = module.resource_group_dns_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_hub_dns_region1" {
  name                         = "peer-${azurerm_virtual_network.vnet_dns_region1.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name          = azurerm_virtual_network.vnet_hub_region1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_dns_region1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  depends_on                   = [azurerm_virtual_network_gateway.vng_region1]
}

resource "azurerm_virtual_network_peering" "vnet_peering_dns_hub_region1" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region1.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_dns_region1.name
  resource_group_name          = azurerm_virtual_network.vnet_dns_region1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network_gateway.vng_region1]
}

resource "azurerm_route_table" "route_table_dns_region1" {
  name                          = "rt-dns-${module.resource_group_dns_region1.resource_group_location}"
  location                      = module.resource_group_dns_region1.resource_group_location
  resource_group_name           = module.resource_group_dns_region1.resource_group_name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route_fw_dns_region1" {
  name                   = "udr-0.0.0.0_0-to-fw"
  resource_group_name    = module.resource_group_dns_region1.resource_group_name
  route_table_name       = azurerm_route_table.route_table_dns_region1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw_region1.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "subnet_dc_region1_route_table_dns_region1_association" {
  subnet_id      = azurerm_subnet.subnet_dc_region1.id
  route_table_id = azurerm_route_table.route_table_dns_region1.id
}

resource "azurerm_subnet_route_table_association" "subnet_dns_forwarder_region1_route_table_dns_region1_association" {
  subnet_id      = azurerm_subnet.subnet_dns_forwarder_region1.id
  route_table_id = azurerm_route_table.route_table_dns_region1.id
}

module "vm_dc_region1" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-dc-${var.region1}"
  computer_name = "vm-dc-weu"
  location            = module.resource_group_dns_region1.resource_group_location
  resource_group_name = module.resource_group_dns_region1.resource_group_name
  vm_subnet_id        = azurerm_subnet.subnet_dc_region1.id
  tags                = local.common_tags
}

module "vm_dns_region1" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-dns-${var.region1}"
  computer_name = "vm-dns-weu"
  location            = module.resource_group_dns_region1.resource_group_location
  resource_group_name = module.resource_group_dns_region1.resource_group_name
  vm_subnet_id        = azurerm_subnet.subnet_dc_region1.id
  tags                = local.common_tags
}


