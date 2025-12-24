// Apps Resource Group - Region 1
module "resource_group_apps_region1" {
  source   = "../modules/resource-group"
  name     = "rg-apps-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}

// Virtual Network -  Apps
resource "azurerm_virtual_network" "vnet_apps_region1" {
  name                = "vnet-apps-${var.region1}"
  location            = var.region1
  resource_group_name = module.resource_group_apps_region1.resource_group_name
  address_space       = [var.vnet_apps_address_space_region1]
  tags                = local.common_tags
}

// Endpoints Subnet
resource "azurerm_subnet" "subnet_endpoints_apps_region1" {
  name                                          = "snet-endpoints"
  address_prefixes                              = [cidrsubnet(var.vnet_apps_address_space_region1, 1, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_apps_region1.name
  resource_group_name                           = module.resource_group_apps_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Virtual Network Integration Subnet
resource "azurerm_subnet" "subnet_vni_apps_region1" {
  name                 = "snet-vni"
  address_prefixes     = [cidrsubnet(var.vnet_apps_address_space_region1, 1, 1)]
  virtual_network_name = azurerm_virtual_network.vnet_apps_region1.name
  resource_group_name  = module.resource_group_apps_region1.resource_group_name
  delegation {
    name = "app-service-delegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Virtual Hub - VNET Connection
resource "azurerm_virtual_hub_connection" "vhub_connection_apps_region1" {
  name                      = "vhub-connection-${azurerm_virtual_network.vnet_apps_region1.name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub_region1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet_apps_region1.id
  internet_security_enabled = true
}

// Private DNS Resolver - Virtual Network Link
resource "azurerm_private_dns_resolver_virtual_network_link" "private_dns_resolver_virtual_network_link_vnet_apps_region1" {
  name                      = "link-${azurerm_virtual_network.vnet_apps_region1.name}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset_region1.id
  virtual_network_id        = azurerm_virtual_network.vnet_apps_region1.id
}

// App Service Plan - Region 1
resource "azurerm_service_plan" "app_service_plan_region1" {
  name                = "asp-linux-${var.region1}"
  resource_group_name = module.resource_group_apps_region1.resource_group_name
  location            = var.region1
  os_type             = "Linux"
  sku_name            = "P1v2"
}

// App Service - Linux
resource "azurerm_linux_web_app" "linux_web_app_region1" {
  name                          = "app-linux-${var.region1}"
  resource_group_name           = module.resource_group_apps_region1.resource_group_name
  location                      = var.region1
  service_plan_id               = azurerm_service_plan.app_service_plan_region1.id
  enabled                       = true
  https_only                    = true
  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.subnet_vni_apps_region1.id
  vnet_image_pull_enabled       = true
  site_config {
    always_on              = true
    minimum_tls_version    = "1.3"
    vnet_route_all_enabled = true
  }
  tags = local.common_tags
}

// Private Endpoint
resource "azurerm_private_endpoint" "linux_web_app_private_endpoint_region1" {
  name                          = "pep-${azurerm_linux_web_app.linux_web_app_region1.name}"
  custom_network_interface_name = "nic-pep-${azurerm_linux_web_app.linux_web_app_region1.name}"
  resource_group_name           = module.resource_group_apps_region1.resource_group_name
  location                      = var.region1
  subnet_id                     = azurerm_subnet.subnet_endpoints_apps_region1.id

  private_service_connection {
    name                           = "pep-app-linux-${var.region1}"
    private_connection_resource_id = azurerm_linux_web_app.linux_web_app_region1.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "websites-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.websites_private_dns_zone.id]
  }
  tags = local.common_tags
}