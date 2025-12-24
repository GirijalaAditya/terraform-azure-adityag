// Azure Firewall - Region 1
resource "azurerm_firewall" "afw_vhub_region2" {
  name                = "afw-${var.region2}"
  location            = azurerm_virtual_hub.vhub_region2.location
  resource_group_name = azurerm_virtual_hub.vhub_region2.resource_group_name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Basic"
  zones               = ["1", "2", "3"]
  private_ip_ranges   = ["IANAPrivateRanges"]

  firewall_policy_id = azurerm_firewall_policy.afwp_vhub_region2.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub_region2.id
    public_ip_count = 1
  }

  tags = local.common_tags
}

// Azure Firewall Policy - Region 1
resource "azurerm_firewall_policy" "afwp_vhub_region2" {
  name                = "afwp-${var.region2}"
  resource_group_name = azurerm_virtual_hub.vhub_region2.resource_group_name
  location            = azurerm_virtual_hub.vhub_region2.location
  sku                 = "Basic"
  tags                = local.common_tags
}

// Azure Firewall Policy Rule Collection Group - Region 1
resource "azurerm_firewall_policy_rule_collection_group" "rcg_vhub_region2" {
  name               = "rcg"
  firewall_policy_id = azurerm_firewall_policy.afwp_vhub_region2.id
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


data "azurerm_monitor_diagnostic_categories" "categories_afw_vhub_region2" {
  resource_id = azurerm_firewall.afw_vhub_region2.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_afw_vhub_region2" {
  name                           = "diagnostics"
  target_resource_id             = azurerm_firewall.afw_vhub_region2.id
  log_analytics_workspace_id     = module.log_analytics_workspace_region2.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories_afw_vhub_region2.log_category_types

    content {
      category = enabled_log.key
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories_afw_vhub_region2.metrics

    content {
      category = enabled_metric.key
    }
  }
}
