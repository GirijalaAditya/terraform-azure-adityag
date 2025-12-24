// Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

// Gateway Subnet
data "azurerm_subnet" "gateway_subnet" {
  name = "GatewaySubnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

// Azure Virtual Network Gateway Public IP
module "azure_vng_public_ip" {
  source = "../../modules/azure-public-ip"
  count = var.active_active ? 2 : 1
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  name = "pip-vng-${data.azurerm_resource_group.rg.location}"
  zones = ["1","2","3"]
  tags = var.tags
}

// Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vng" {
  name                = "vng-${data.azurerm_resource_group.rg.location}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  vpn_type = "RouteBased"
  type     = var.type
  sku           = var.sku
  generation = var.generation
  active_active = var.active_active
  enable_bgp    = var.enable_bgp

  dynamic "ip_configuration" {
    for_each = var.active_active ? [1, 2] : [1]
    content {
      name = "ipconfig-vng-${ip_configuration.key}"
      public_ip_address_id = module.azure_vng_public_ip[ip_configuration.key].public_ip_address
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.gateway_subnet.id
    }
   }

  dynamic "bgp_settings" {
    for_each = var.enable_bgp ? [1] : []
    content {
      asn = var.bgp_asn
    }
  }

  tags = var.tags
}
