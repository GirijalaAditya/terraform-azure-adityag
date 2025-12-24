// Generic Variables
location         = "westeurope"
environment      = "prod"
business_divsion = "devops"

// Virtual Network
virtual_network_address_space = "172.27.0.0/20"

// Virtual Network Gateway
vng_sku        = "VpnGw2AZ"
vng_generation = "Generation2"
vng_bgn_asn    = "65101"
vpn_client_configuration = {
  vpn_address_space = ["192.170.0.0/20"]
  aad_audience      = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
}
