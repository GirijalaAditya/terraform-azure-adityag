// Local Network Gateway 1 - Region 1
resource "azurerm_local_network_gateway" "local_network_gateway_01_region1" {
  name                = "lgw-vwan-gw-${var.region1}-01"
  location            = module.resource_group_onprem_region1.resource_group_location
  resource_group_name = module.resource_group_onprem_region1.resource_group_name
  gateway_address     = azurerm_vpn_gateway.vpn_gateway_vhub_region1.ip_configuration[0].public_ip_address

  bgp_settings {
    asn                 = 65515
    bgp_peering_address = tolist(azurerm_vpn_gateway.vpn_gateway_vhub_region1.bgp_settings[0].instance_0_bgp_peering_address[0].default_ips)[0]
  }

  tags = local.common_tags
}

// Local Network Gateway 2 - Region 1
resource "azurerm_local_network_gateway" "local_network_gateway_02_region1" {
  name                = "lgw-vwan-gw-${var.region1}-02"
  location            = module.resource_group_onprem_region1.resource_group_location
  resource_group_name = module.resource_group_onprem_region1.resource_group_name
  gateway_address     = azurerm_vpn_gateway.vpn_gateway_vhub_region1.ip_configuration[1].public_ip_address

  bgp_settings {
    asn                 = 65515
    bgp_peering_address = tolist(azurerm_vpn_gateway.vpn_gateway_vhub_region1.bgp_settings[0].instance_1_bgp_peering_address[0].default_ips)[0]
  }

  tags = local.common_tags
}
