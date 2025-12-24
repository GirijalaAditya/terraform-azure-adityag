resource "azurerm_route_table" "route_table_spoke_1" {
  name                          = "rt-spoke-1-${module.resource_group_spoke_1.resource_group_location}"
  location                      = module.resource_group_spoke_1.resource_group_location
  resource_group_name           = module.resource_group_spoke_1.resource_group_name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route_fw_spoke_1" {
  name                   = "udr-0.0.0.0_0-to-fw"
  resource_group_name    = module.resource_group_spoke_1.resource_group_name
  route_table_name       = azurerm_route_table.route_table_spoke_1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "subnet_spoke_1_workloads_route_table_spoke_1_association" {
  subnet_id      = azurerm_subnet.subnet_spoke_1_workloads.id
  route_table_id = azurerm_route_table.route_table_spoke_1.id
  depends_on     = [azurerm_virtual_network.vnet_spoke_1]
}