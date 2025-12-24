# // Private DNS Zones
# resource "azurerm_private_dns_zone" "private_dns_zones" {
#   for_each            = toset(var.private_dns_zones)
#   name                = each.value
#   resource_group_name = module.resource_group_private_dns.resource_group_name
# }

# // Private DNS Zones - Virtual Network Link
# resource "azurerm_private_dns_zone_virtual_network_link" "this" {
#   for_each              = azurerm_private_dns_zone.private_dns_zones
#   name                  = "link-${azurerm_virtual_network.vnet_dns.name}"
#   resource_group_name   = module.resource_group_private_dns.resource_group_name
#   private_dns_zone_name = each.value.name
#   virtual_network_id    = azurerm_virtual_network.vnet_dns.id
#   resolution_policy     = "NxDomainRedirect"
# }