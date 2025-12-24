resource "azurerm_vpn_gateway_connection" "vpn_gateway_connection_site_vng_01_region1" {
  name                      = "vpn-gateway-connection-vng-${var.region1}-01"
  vpn_gateway_id            = azurerm_vpn_gateway.vpn_gateway_vhub_region1.id
  remote_vpn_site_id        = azurerm_vpn_site.vpn_site_vng_01_region1.id
  internet_security_enabled = true
  vpn_link {
    name             = "Link"
    vpn_site_link_id = azurerm_vpn_site.vpn_site_vng_01_region1.link[0].id
    bandwidth_mbps   = 100
    bgp_enabled      = true
    protocol         = "IKEv2"
    shared_key       = "Welcome2u2@@@"
  }
}

resource "azurerm_vpn_gateway_connection" "vpn_gateway_connection_site_vng_02_region1" {
  name                      = "vpn-gateway-connection-vng-${var.region1}-02"
  vpn_gateway_id            = azurerm_vpn_gateway.vpn_gateway_vhub_region1.id
  remote_vpn_site_id        = azurerm_vpn_site.vpn_site_vng_02_region1.id
  internet_security_enabled = true
  vpn_link {
    name             = "Link"
    vpn_site_link_id = azurerm_vpn_site.vpn_site_vng_02_region1.link[0].id
    bandwidth_mbps   = 100
    bgp_enabled      = true
    protocol         = "IKEv2"
    shared_key       = "Welcome2u2@@@"
  }
}