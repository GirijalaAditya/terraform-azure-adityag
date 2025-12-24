resource "azurerm_vpn_server_configuration" "p2s_vpn_configuration" {
  name                     = "p2s-vpn-configuration"
  resource_group_name      = azurerm_virtual_wan.vwan.resource_group_name
  location                 = azurerm_virtual_wan.vwan.location
  vpn_authentication_types = ["AAD"]     # Possible values are AAD (Azure Active Directory), Certificate and Radius.
  vpn_protocols            = ["OpenVPN"] # Possible values are IkeV2 and OpenVPN.

  azure_active_directory_authentication {
    audience = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
    issuer   = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
    tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
  }
}