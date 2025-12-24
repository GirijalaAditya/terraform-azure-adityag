// Azure Virtual Hub - VPN Site 1 - Region 1
resource "azurerm_vpn_site" "vpn_site_vng_01_region1" {
  device_vendor       = "Azure"
  name                = "vpn-site-vng-${var.region1}-01"
  location            = var.region1
  resource_group_name = azurerm_virtual_hub.vhub_region1.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  link {
    name          = "Link"
    provider_name = "Azure"
    speed_in_mbps = 100
    ip_address    = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses[0]
    bgp {
      asn             = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].asn
      peering_address = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].peering_addresses[0].default_addresses[0]
    }
  }
}

// Azure Virtual Hub - VPN Site 2 - Region 1
resource "azurerm_vpn_site" "vpn_site_vng_02_region1" {
  device_vendor       = "Azure"
  name                = "vpn-site-vng-${var.region1}-02"
  location            = var.region1
  resource_group_name = azurerm_virtual_hub.vhub_region1.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  link {
    name          = "Link"
    provider_name = "Azure"
    speed_in_mbps = 100
    ip_address    = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].peering_addresses[1].tunnel_ip_addresses[0]
    bgp {
      asn             = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].asn
      peering_address = azurerm_virtual_network_gateway.vng_region1.bgp_settings[0].peering_addresses[1].default_addresses[0]
    }
  }
}
