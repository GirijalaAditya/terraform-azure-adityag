resource "azurerm_vpn_gateway" "vpn_gateway_vhub_region1" {
  name                = "s2s-vpn-gateway-${var.region1}"
  location            = azurerm_virtual_hub.vhub_region1.location
  resource_group_name = azurerm_virtual_hub.vhub_region1.resource_group_name
  virtual_hub_id      = azurerm_virtual_hub.vhub_region1.id
  routing_preference  = "Microsoft Network"
  scale_unit          = 2
  tags                = local.common_tags
}