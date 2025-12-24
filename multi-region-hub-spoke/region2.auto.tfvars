region2                        = "eastus"
vnet_hub_region2_address_space = "172.22.0.0/20"
vpn_region2_client_configuration = {
  vpn_address_space = ["192.172.0.0/20"]
  aad_audience      = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
}