// Azure Virtual Hub - Region 1
resource "azurerm_virtual_hub" "vhub_region2" {
  name                                   = "vhub-${var.region2}"
  resource_group_name                    = module.resource_group_region2.resource_group_name
  location                               = var.region2
  sku                                    = "Standard"
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = var.vhub_address_space_region2
  virtual_router_auto_scale_min_capacity = 2
  branch_to_branch_traffic_enabled       = true
  hub_routing_preference                 = "VpnGateway"
  tags                                   = local.common_tags
}