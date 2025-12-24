variable "resource_group_name" {
  type        = string
  description = "Resource Group Name "
  nullable    = false
}

variable "location" {
  type        = string
  description = "Location"
  nullable    = false
}

variable "vm_name" {
  type        = string
  description = "Virtual Machine Name"
  nullable    = false
}

variable "vm_subnet_id" {
  description = "VM Subnet ID"
  type        = string
  nullable    = false
}

variable "vm_size" {
  type    = string
  default = "Standard_B1ms" #"Standard_D2as_v4" # "Standard_B1ms" # Standard_B2ls_v2 # Standard_B2s_v2
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type    = string
  default = "Welcome2u2" # don't do this
}

variable "public_ip_required" {
  type    = bool
  default = false
}

variable "install_script" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}