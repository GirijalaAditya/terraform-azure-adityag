// Azure Firewall Subnet
resource "azurerm_subnet" "subnet_firewall" {
  name                                          = "AzureFirewallSubnet"
  address_prefixes                              = [cidrsubnet(var.virtual_network_address_space, 6, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub.name
  resource_group_name                           = module.resource_group_network.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = true
}

// Azure Firewall Management Subnet
resource "azurerm_subnet" "subnet_firewall_mgmt" {
  name                                          = "AzureFirewallManagementSubnet"
  address_prefixes                              = [cidrsubnet(var.virtual_network_address_space, 6, 1)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub.name
  resource_group_name                           = module.resource_group_network.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = true
}

// Azure Firewall Public IP
module "azure_firewall_public_ip" {
  source              = "../modules/azure-public-ip"
  resource_group_name = module.resource_group_network.resource_group_name
  location            = module.resource_group_network.resource_group_location
  name                = "pip-afw-${var.location}"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Azure Firewall Management Public IP
module "azure_firewall_mgmt_public_ip" {
  source              = "../modules/azure-public-ip"
  resource_group_name = module.resource_group_network.resource_group_name
  location            = module.resource_group_network.resource_group_location
  name                = "pip-afw-mgmt-${var.location}"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Azure Firewall
resource "azurerm_firewall" "afw" {
  name                = "afw-${var.location}"
  location            = module.resource_group_network.resource_group_location
  resource_group_name = module.resource_group_network.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = ["1", "2", "3"]
  private_ip_ranges   = ["IANAPrivateRanges"]

  firewall_policy_id = azurerm_firewall_policy.afwp.id

  ip_configuration {
    name                 = "ipconfig-firewall"
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = module.azure_firewall_public_ip.public_ip_address_id
  }

  management_ip_configuration {
    name                 = "ipconfig-firewall-mgmt"
    subnet_id            = azurerm_subnet.subnet_firewall_mgmt.id
    public_ip_address_id = module.azure_firewall_mgmt_public_ip.public_ip_address_id
  }

  tags = local.common_tags
}

// Azure Firewall Policy
resource "azurerm_firewall_policy" "afwp" {
  name                = "afwp"
  resource_group_name = module.resource_group_network.resource_group_name
  location            = module.resource_group_network.resource_group_location
  sku                 = "Standard"
  tags                = local.common_tags
}

// Azure Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  name               = "rcg"
  firewall_policy_id = azurerm_firewall_policy.afwp.id
  priority           = "60000"

  application_rule_collection {
    name     = "allow-app-rc"
    priority = 60000
    action   = "Allow"

    rule {
      name              = "allow-all"
      source_addresses  = ["*"]
      destination_fqdns = ["*"]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "allow-network-rc"
    priority = 50000
    action   = "Allow"

    rule {
      name                  = "allow-all"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}
