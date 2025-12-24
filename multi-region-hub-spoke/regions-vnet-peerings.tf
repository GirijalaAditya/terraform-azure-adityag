resource "azurerm_virtual_network_peering" "vnet_peering_region1_region2" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region2.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name          = module.resource_group_hub_region1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_region2_region1" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region1.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region2.name
  resource_group_name          = module.resource_group_hub_region2.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_region1_region3" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region3.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name          = module.resource_group_hub_region1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region3.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_region3_region1" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region1.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region3.name
  resource_group_name          = module.resource_group_hub_region3.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_region2_region3" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region3.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region2.name
  resource_group_name          = module.resource_group_hub_region2.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region3.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_region3_region2" {
  name                         = "peer-${azurerm_virtual_network.vnet_hub_region2.name}"
  virtual_network_name         = azurerm_virtual_network.vnet_hub_region3.name
  resource_group_name          = module.resource_group_hub_region3.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub_region2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}