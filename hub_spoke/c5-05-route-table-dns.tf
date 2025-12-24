resource "azurerm_route_table" "route_table_dns" {
  name                          = "rt-dns-${module.resource_group_dns.resource_group_location}"
  location                      = module.resource_group_dns.resource_group_location
  resource_group_name           = module.resource_group_dns.resource_group_name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route_fw_dns" {
  name                   = "udr-0.0.0.0_0-to-fw"
  resource_group_name    = module.resource_group_dns.resource_group_name
  route_table_name       = azurerm_route_table.route_table_dns.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "subnet_dns_workloads_route_table_dns_association" {
  subnet_id      = azurerm_subnet.subnet_dns_workloads.id
  route_table_id = azurerm_route_table.route_table_dns.id
  depends_on     = [azurerm_virtual_network.vnet_dns]
}