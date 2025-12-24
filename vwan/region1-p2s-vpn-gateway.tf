resource "azurerm_point_to_site_vpn_gateway" "p2s_vpn_gateway_vhub_region1" {
  name                        = "p2s-vpn-gateway-${var.region1}"
  location                    = azurerm_virtual_hub.vhub_region1.location
  resource_group_name         = azurerm_virtual_hub.vhub_region1.resource_group_name
  virtual_hub_id              = azurerm_virtual_hub.vhub_region1.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s_vpn_configuration.id
  scale_unit                  = 1

  connection_configuration {
    name                      = "p2s-vpn-configuration"
    internet_security_enabled = true # set to true for your clients to be properly configured for forced-tunneling

    vpn_client_address_pool {
      address_prefixes = [var.vpn_client_address_pool_region1]
    }
  }
}