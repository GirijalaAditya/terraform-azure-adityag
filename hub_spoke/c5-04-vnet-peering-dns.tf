resource "azurerm_virtual_network_peering" "vnet_peering_hubdns" {
  name                         = "peer-${azurerm_virtual_network.vnet_dns.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_dns.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  depends_on                   = [azurerm_virtual_network_gateway.vng]
}

resource "azurerm_virtual_network_peering" "vnet_peeringsdns_hub" {
  name                         = "peer-hub"
  virtual_network_name         = azurerm_virtual_network.vnet_dns.name
  resource_group_name          = azurerm_virtual_network.vnet_dns.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network_gateway.vng]
}