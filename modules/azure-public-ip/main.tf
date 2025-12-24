resource "azurerm_public_ip" "pip" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  ip_version          = "IPv4"
  zones               = var.zones
  ddos_protection_mode = "VirtualNetworkInherited"
  tags = var.tags
}