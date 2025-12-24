region1                        = "westeurope"
vnet_hub_region1_address_space = "172.21.0.0/20"
vpn_region1_client_configuration = {
  vpn_address_space = ["192.171.0.0/20"]
  aad_audience      = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
}