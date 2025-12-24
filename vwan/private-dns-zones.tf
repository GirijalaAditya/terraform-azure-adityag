variable "private_dns_zones" {
  type        = list(string)
  description = "Private DNS Zones"
}

// Resource Group - Private DNS
module "resource_group_private_dns" {
  source   = "../modules/resource-group"
  name     = "rg-private-dns"
  location = var.region1
  tags     = local.common_tags
}

// Private DNS Zones
resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.value
  resource_group_name = module.resource_group_private_dns.resource_group_name
}