resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = "private-dns-resolver"
  resource_group_name = module.resource_group_dns.resource_group_name
  location            = module.resource_group_dns.resource_group_location
  virtual_network_id  = azurerm_virtual_network.vnet_dns.id
  tags                = local.common_tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "private_dns_resolver_inbound_endpoint" {
  name                    = "private-dns-resolver-inbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = module.resource_group_dns.resource_group_location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet_dns_inbound.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "private_dns_resolver_outbound_endpoint" {
  name                    = "private-dns-resolver-outbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = module.resource_group_dns.resource_group_location
  subnet_id               = azurerm_subnet.subnet_dns_outbound.id
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "private_dns_resolver_dns_forwarding_ruleset" {
  name                                       = "private-dns-resolver-dns-forwarding-ruleset"
  resource_group_name                        = module.resource_group_dns.resource_group_name
  location                                   = module.resource_group_dns.resource_group_location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.private_dns_resolver_outbound_endpoint.id]
}

resource "azurerm_private_dns_resolver_virtual_network_link" "private_dns_resolver_virtual_network_link" {
  name                      = "private-dns-resolver-vnet-link"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset.id
  virtual_network_id        = azurerm_virtual_network.vnet_dns.id
}