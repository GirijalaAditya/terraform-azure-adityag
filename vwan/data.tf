data "azurerm_client_config" "current" {}


// Websites Private DNS Zone
data "azurerm_private_dns_zone" "websites_private_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "rg-private-dns"
  depends_on = [ azurerm_private_dns_zone.private_dns_zones  ]
}