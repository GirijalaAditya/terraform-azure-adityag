locals {
  aksServiceCidr       = cidrsubnet(var.virtual_network_address_space, 3, 3)
  aksDnsServiceIP      = cidrhost(local.aksServiceCidr, 10)
  appGwCidr            = cidrsubnet(var.virtual_network_address_space, 5, 0)
  aksNodeCidr          = cidrsubnet(var.virtual_network_address_space, 5, 1)
  privateEndpointsCidr = cidrsubnet(var.virtual_network_address_space, 3, 1)
  aksPodCidr           = cidrsubnet(var.virtual_network_address_space, 1, 1)
  aciCidr              = cidrsubnet(var.virtual_network_address_space, 5, 2)
}

// Virtual Network
resource "azurerm_virtual_network" "virtual_network_aks" {
  name                = "vnet-aks-${module.resource_group.resource_group_location}"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  address_space       = [var.virtual_network_address_space]
  tags = merge({
    purpose = "Virtual Network"
  }, local.common_tags)

}

// Application Gateway Subnet
resource "azurerm_subnet" "subnet_app_gateway" {
  name                                          = "snet-app-gw"
  resource_group_name                           = module.resource_group.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network_aks.name
  address_prefixes                              = [local.appGwCidr]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// AKS Nodes Subet
resource "azurerm_subnet" "subnet_aks_nodes" {
  name                                          = "snet-aks-nodes"
  resource_group_name                           = module.resource_group.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network_aks.name
  address_prefixes                              = [local.aksNodeCidr]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// AKS Pods Subnet
resource "azurerm_subnet" "subnet_aks_pods" {
  name                                          = "snet-aks-pods"
  resource_group_name                           = module.resource_group.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network_aks.name
  address_prefixes                              = [local.aksPodCidr]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
  delegation {
    name = "aks-delegation"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.CognitiveServices"
  ]
}

// ACI Subnet
resource "azurerm_subnet" "subnet_aci" {
  name                                          = "snet-aci"
  resource_group_name                           = module.resource_group.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network_aks.name
  address_prefixes                              = [local.aciCidr]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
  delegation {
    name = "aci-delegation"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

// Private Endpoint Subnet
resource "azurerm_subnet" "subnet_private_endpoints" {
  name                                          = "snet-private-endpoints"
  resource_group_name                           = module.resource_group.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network_aks.name
  address_prefixes                              = [local.privateEndpointsCidr]
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

// AKS Nodes Subnet - NAT Gateway Association
resource "azurerm_subnet_nat_gateway_association" "subnet_aks_nodes_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_aks_nodes.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

// AKS Pods Subnet - NAT Gateway Association
resource "azurerm_subnet_nat_gateway_association" "subnet_aks_pods_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_aks_pods.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

// Application Gateway Network Security Group
resource "azurerm_network_security_group" "nsg_app_gateway" {
  name                = "nsg-app-gw"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name

  security_rule {
    name                       = "Public-Ingress-to-AppGateway"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AppGateway-Backend-Health"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  tags = merge({
    purpose = "Application Gateway Network Security Group"
  }, local.common_tags)
}

// AKS Nodes Network Security Group
resource "azurerm_network_security_group" "nsg_aks_nodes" {
  name                = "nsg-aks-nodes"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name

  tags = merge({
    purpose = "AKS Nodes Network Security Group"
  }, local.common_tags)
}

// AKS Pods Network Security Group
resource "azurerm_network_security_group" "nsg_aks_pods" {
  name                = "nsg-aks-pods"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name

  tags = merge({
    purpose = "AKS Pods Network Security Group"
  }, local.common_tags)
}

// Private Endpoints Network Security Group
resource "azurerm_network_security_group" "nsg_private_endpoints" {
  name                = "nsg-private-endpoints"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name

  tags = merge({
    purpose = "Private Endpoints Network Security Group"
  }, local.common_tags)
}

// Application Gateway Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "subnet_app_gateway_network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet_app_gateway.id
  network_security_group_id = azurerm_network_security_group.nsg_app_gateway.id
}

// AKS Nodes Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "subnet_aks_nodes_network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet_aks_nodes.id
  network_security_group_id = azurerm_network_security_group.nsg_aks_nodes.id
}

// AKS Pods Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "subnet_aks_pods_network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet_aks_pods.id
  network_security_group_id = azurerm_network_security_group.nsg_aks_pods.id
}

// Private Endpoints Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "subnet_private_endpoints_network_security_group_association" {
  subnet_id                 = azurerm_subnet.subnet_private_endpoints.id
  network_security_group_id = azurerm_network_security_group.nsg_private_endpoints.id
}

// Azure NAT Gateway Public IP
module "azure_nat_gateway_public_ip" {
  source              = "../modules/azure-public-ip"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  name                = "pip-nat-gateway-${module.resource_group.resource_group_location}"
  zones               = ["1", "2", "3"]
  tags = merge({
    purpose = "NAT Gateway Public IP"
  }, local.common_tags)
}

// Azure NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "nat-gateway-${module.resource_group.resource_group_location}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags = merge({
    purpose = "NAT Gateway"
  }, local.common_tags)
}

// NAT Gateway Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "azurerm_nat_gateway_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = module.azure_nat_gateway_public_ip.public_ip_address_id
}