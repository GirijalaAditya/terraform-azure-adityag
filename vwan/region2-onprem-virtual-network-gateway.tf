// On-Prem Virtual Network
resource "azurerm_virtual_network" "vnet_onprem_region2" {
  name                = "vnet-onprem-${module.resource_group_onprem_region2.resource_group_location}"
  location            = module.resource_group_onprem_region2.resource_group_location
  resource_group_name = module.resource_group_onprem_region2.resource_group_name
  address_space       = [var.vnet_onprem_address_space_region2]
  tags                = local.common_tags
}

// Gateway Subnet
resource "azurerm_subnet" "subnet_gateway_region2" {
  name                                          = "GatewaySubnet"
  address_prefixes                              = [cidrsubnet(var.vnet_onprem_address_space_region2, 6, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_onprem_region2.name
  resource_group_name                           = module.resource_group_onprem_region2.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Virtual Network Gateway Public IP
module "azure_vng_public_ip_1_region2" {
  source              = "../modules/azure-public-ip"
  location            = module.resource_group_onprem_region2.resource_group_location
  resource_group_name = module.resource_group_onprem_region2.resource_group_name
  name                = "pip-vng-${var.region2}-01"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Azure Virtual Network Gateway Public IP
module "azure_vng_public_ip_2_region2" {
  source              = "../modules/azure-public-ip"
  location            = module.resource_group_onprem_region2.resource_group_location
  resource_group_name = module.resource_group_onprem_region2.resource_group_name
  name                = "pip-vng-${var.region2}-02"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vng_region2" {
  name                = "vng-${var.region2}"
  location            = module.resource_group_onprem_region2.resource_group_location
  resource_group_name = module.resource_group_onprem_region2.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = true
  enable_bgp          = true
  sku                 = "VpnGw2AZ"
  generation          = "Generation2"

  ip_configuration {
    name                          = "ipconfig-vng-01"
    public_ip_address_id          = module.azure_vng_public_ip_1_region2.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_gateway_region2.id
  }

  ip_configuration {
    name                          = "ipconfig-vng-02"
    public_ip_address_id          = module.azure_vng_public_ip_2_region2.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_gateway_region2.id
  }

  bgp_settings {
    asn = var.vng_onprem_bgp_asn_region2
  }

  tags = local.common_tags
}
