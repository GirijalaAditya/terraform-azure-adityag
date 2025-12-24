resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_site_vng_01_region2" {
  name                       = "vcn-onprem-vwan-${var.region2}-01"
  location                   = module.resource_group_onprem_region2.resource_group_location
  resource_group_name        = module.resource_group_onprem_region2.resource_group_name
  enable_bgp                 = true
  type                       = "IPsec"
  connection_mode            = "Default"
  connection_protocol        = "IKEv2"
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_01_region2.id
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng_region2.id
  dpd_timeout_seconds        = 45
  shared_key                 = "Welcome2u2@@@"
}

resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_site_vng_02_region2" {
  name                       = "vcn-onprem-vwan-${var.region2}-02"
  location                   = module.resource_group_onprem_region2.resource_group_location
  resource_group_name        = module.resource_group_onprem_region2.resource_group_name
  enable_bgp                 = true
  type                       = "IPsec"
  connection_mode            = "Default"
  connection_protocol        = "IKEv2"
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_02_region2.id
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng_region2.id
  dpd_timeout_seconds        = 45
  shared_key                 = "Welcome2u2@@@"
}