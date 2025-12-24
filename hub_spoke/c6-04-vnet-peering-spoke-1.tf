resource "azurerm_virtual_network_peering" "vnet_peering_hub_spoke1" {
  name                         = "peer-${azurerm_virtual_network.vnet_spoke_1.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  depends_on                   = [azurerm_virtual_network_gateway.vng]
}

resource "azurerm_virtual_network_peering" "vnet_peerings_spoke1_hub" {
  name                         = "peer-hub"
  virtual_network_name         = azurerm_virtual_network.vnet_spoke_1.name
  resource_group_name          = azurerm_virtual_network.vnet_spoke_1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network_gateway.vng]
}