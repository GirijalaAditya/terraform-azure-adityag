// Azure Firewall Subnet
resource "azurerm_subnet" "subnet_firewall_region1" {
  name                                          = "AzureFirewallSubnet"
  address_prefixes                              = [cidrsubnet(var.vnet_hub_region1_address_space, 6, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name                           = module.resource_group_hub_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Firewall Management Subnet
resource "azurerm_subnet" "subnet_firewall_mgmt_region1" {
  name                                          = "AzureFirewallManagementSubnet"
  address_prefixes                              = [cidrsubnet(var.vnet_hub_region1_address_space, 6, 1)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name                           = module.resource_group_hub_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Firewall Public IP
module "azure_firewall_public_ip_region1" {
  source              = "../modules/azure-public-ip"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  name                = "pip-afw-${var.region1}"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Azure Firewall Management Public IP
module "azure_firewall_mgmt_public_ip_region1" {
  source              = "../modules/azure-public-ip"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  name                = "pip-afw-mgmt-${var.region1}"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Azure Firewall
resource "azurerm_firewall" "afw_region1" {
  name                = "afw-${var.region1}"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = ["1", "2", "3"]
  private_ip_ranges   = ["IANAPrivateRanges"]

  firewall_policy_id = azurerm_firewall_policy.afwp_region1.id

  ip_configuration {
    name                 = "ipconfig-firewall"
    subnet_id            = azurerm_subnet.subnet_firewall_region1.id
    public_ip_address_id = module.azure_firewall_public_ip_region1.public_ip_address_id
  }

  management_ip_configuration {
    name                 = "ipconfig-firewall-mgmt"
    subnet_id            = azurerm_subnet.subnet_firewall_mgmt_region1.id
    public_ip_address_id = module.azure_firewall_mgmt_public_ip_region1.public_ip_address_id
  }

  tags = local.common_tags
}

// Azure Firewall Policy
resource "azurerm_firewall_policy" "afwp_region1" {
  name                = "afwp-${var.region1}"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  sku                 = "Standard"
  tags                = local.common_tags
}

// Azure Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "rcg_region1" {
  name               = "rcg"
  firewall_policy_id = azurerm_firewall_policy.afwp_region1.id
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

data "azurerm_monitor_diagnostic_categories" "categories_region1" {
  resource_id = azurerm_firewall.afw_region1.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_region1" {
  name                           = "diagnostics"
  target_resource_id             = azurerm_firewall.afw_region1.id
  log_analytics_workspace_id     = module.log_analytics_workspace_region1.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories_region1.log_category_types

    content {
      category = enabled_log.key
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories_region1.metrics

    content {
      category = enabled_metric.key
    }
  }
}
