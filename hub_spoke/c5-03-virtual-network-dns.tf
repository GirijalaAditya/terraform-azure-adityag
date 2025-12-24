// Virtual Network -  DNS
resource "azurerm_virtual_network" "vnet_dns" {
  name                = "vnet-dns-${module.resource_group_dns.resource_group_location}"
  location            = module.resource_group_dns.resource_group_location
  resource_group_name = module.resource_group_dns.resource_group_name
  address_space       = ["172.28.0.0/24"]
  tags                = local.common_tags
}

// Subnet Workloads - DNS 
resource "azurerm_subnet" "subnet_dns_workloads" {
  name                                          = "snet-workloads"
  address_prefixes                              = ["172.28.0.0/26"]
  virtual_network_name                          = azurerm_virtual_network.vnet_dns.name
  resource_group_name                           = module.resource_group_dns.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Subnet - DNS Inbound
resource "azurerm_subnet" "subnet_dns_inbound" {
  name                 = "snet-dns-inbound"
  resource_group_name  = module.resource_group_dns.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_dns.name
  address_prefixes     = ["172.28.0.64/26"]
  delegation {
    name = "dns-resolver"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

// Subnet - DNS Outbound
resource "azurerm_subnet" "subnet_dns_outbound" {
  name                 = "snet-dns-outbound"
  resource_group_name  = module.resource_group_dns.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_dns.name
  address_prefixes     = ["172.28.0.128/26"]
  delegation {
    name = "dns-resolver"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}
