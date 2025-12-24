module "public_ip" {
  source = "../azure-public-ip"
  name = "pip-bastion-${var.location}"
  resource_group_name = var.resource_group_name
  zones = ["1","2","3"]
  location = var.location
  tags = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku                    = var.sku
  scale_units            = 2
  zones = ["1","2","3"]
  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = true
  kerberos_enabled       = false
  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = module.public_ip.public_ip_address_id
  }
  tags = var.tags
}
