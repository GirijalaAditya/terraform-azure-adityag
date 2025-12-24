data "azurerm_client_config" "current" {}

// Gateway Subnet
resource "azurerm_subnet" "subnet_gateway_region1" {
  name                                          = "GatewaySubnet"
  address_prefixes                              = [cidrsubnet(var.vnet_hub_region1_address_space, 6, 3)]
  virtual_network_name                          = azurerm_virtual_network.vnet_hub_region1.name
  resource_group_name                           = module.resource_group_hub_region1.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// Azure Virtual Network Gateway Public IP
module "azure_vng_public_ip_region1" {
  source              = "../modules/azure-public-ip"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  name                = "pip-vng-${var.region1}"
  zones               = ["1", "2", "3"]
  tags                = local.common_tags
}

// Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vng_region1" {
  name                = "vng-${var.region1}"
  location            = module.resource_group_hub_region1.resource_group_location
  resource_group_name = module.resource_group_hub_region1.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  enable_bgp          = true
  sku                 = "VpnGw2AZ"
  generation          = "Generation2"

  ip_configuration {
    name                          = "ipconfig-vng"
    public_ip_address_id          = module.azure_vng_public_ip_region1.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_gateway_region1.id
  }

  bgp_settings {
    asn = 65101
  }

  vpn_client_configuration {
    address_space        = var.vpn_region1_client_configuration.vpn_address_space
    aad_audience         = var.vpn_region1_client_configuration.aad_audience
    aad_issuer           = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
    aad_tenant           = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
  }

  tags = local.common_tags
}