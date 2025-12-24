variable "region2" {
  description = "The Azure region for the first virtual hub"
  type        = string
  default     = "eastus"
}

variable "vnet_hub_region2_address_space" {
  type        = string
  description = "Virtual Network Address Space"
  default     = "172.22.0.0/20"
}

variable "vpn_region2_client_configuration" {
  type = object({
    vpn_address_space = list(string)
    aad_audience      = string
  })
  description = "VPN Client Configuration"
  default = {
    vpn_address_space = ["192.172.0.0/20"]
    aad_audience      = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
  }
}