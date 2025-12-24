// Azure Virtual Hub Routing Intent - Region 1
resource "azurerm_virtual_hub_routing_intent" "routing_intent_vhub_region1" {
  name           = "routing-intent-vhub-${var.region1}"
  virtual_hub_id = azurerm_virtual_hub.vhub_region1.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.afw_vhub_region1.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.afw_vhub_region1.id
  }
}
