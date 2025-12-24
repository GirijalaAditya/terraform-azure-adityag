// DNS - Region 1
module "resource_group_dns_region2" {
  source   = "../modules/resource-group"
  name     = "rg-dns-${var.region2}"
  location = var.region2
  tags     = local.common_tags
}

// Virtual Network -  DNS
resource "azurerm_virtual_network" "vnet_dns_region2" {
  name                = "vnet-dns-${var.region2}"
  location            = var.region2
  resource_group_name = module.resource_group_dns_region2.resource_group_name
  address_space       = [var.vnet_dns_address_space_region2]
  tags                = local.common_tags
}

// Subnet - DNS Inbound
resource "azurerm_subnet" "subnet_dns_inbound_region2" {
  name                 = "snet-dns-inbound"
  resource_group_name  = module.resource_group_dns_region2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_dns_region2.name
  address_prefixes     = [cidrsubnet(var.vnet_dns_address_space_region2, 1, 0)]
  delegation {
    name = "dns-resolver"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

// Subnet - DNS Outbound
resource "azurerm_subnet" "subnet_dns_outbound_region2" {
  name                 = "snet-dns-outbound"
  resource_group_name  = module.resource_group_dns_region2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_dns_region2.name
  address_prefixes     = [cidrsubnet(var.vnet_dns_address_space_region2, 1, 1)]
  delegation {
    name = "dns-resolver"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

// Virtual Hub - VNET Connection
resource "azurerm_virtual_hub_connection" "vhub_connection_dns_region2" {
  name                      = "vhub-connection-${azurerm_virtual_network.vnet_dns_region2.name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub_region2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet_dns_region2.id
  internet_security_enabled = true
}

// Private DNS Resolver
resource "azurerm_private_dns_resolver" "private_dns_resolver_region2" {
  name                = "dnspr-${var.region2}"
  resource_group_name = module.resource_group_dns_region2.resource_group_name
  location            = var.region2
  virtual_network_id  = azurerm_virtual_network.vnet_dns_region2.id
  tags                = local.common_tags
}

// Private DNS Resolver - Inbound Endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "private_dns_resolver_inbound_endpoint_region2" {
  name                    = "dnspr-in"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver_region2.id
  location                = var.region2
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet_dns_inbound_region2.id
  }
}

// Private DNS Resolver - Outbound Endpoint
resource "azurerm_private_dns_resolver_outbound_endpoint" "private_dns_resolver_outbound_endpoint_region2" {
  name                    = "dnspr-out"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver_region2.id
  location                = var.region2
  subnet_id               = azurerm_subnet.subnet_dns_outbound_region2.id
}

// Private DNS Resolver - Forwarding Ruleset
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "private_dns_resolver_dns_forwarding_ruleset_region2" {
  name                                       = "dnsfrs-${var.region2}"
  resource_group_name                        = module.resource_group_dns_region2.resource_group_name
  location                                   = var.region2
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.private_dns_resolver_outbound_endpoint_region2.id]
  tags                                       = local.common_tags
}

# // Private DNS Resolver - Virtual Network Link
# resource "azurerm_private_dns_resolver_virtual_network_link" "private_dns_resolver_virtual_network_link_region2" {
#   name                      = "link-${azurerm_virtual_network.vnet_dns_region2.name}"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset_region2.id
#   virtual_network_id        = azurerm_virtual_network.vnet_dns_region2.id
# }

// Private DNS Zones - Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link_region2" {
  for_each              = azurerm_private_dns_zone.private_dns_zones
  name                  = "link-${azurerm_virtual_network.vnet_dns_region2.name}"
  resource_group_name   = module.resource_group_private_dns.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.vnet_dns_region2.id
  registration_enabled  = false
  resolution_policy     = "NxDomainRedirect"
}