// Virtual Network
variable "virtual_network_address_space" {
  type        = string
  description = "Virtual Network Address Space"
}

// Virtual Network Gateway
variable "vng_sku" {
  type        = string
  description = "Virtual Network Gateway SKU"
  default     = "VpnGw2AZ"
}

variable "vng_generation" {
  type        = string
  description = "Virtual Network Gateway Generation"
  default     = "Generation2"
}

variable "vng_bgn_asn" {
  type        = string
  description = "Virtual Network Gateway BGP ASN"
}

variable "vpn_client_configuration" {
  type = object({
    vpn_address_space = list(string)
    aad_audience      = string
  })
  description = "VPN Client Configuration"
}