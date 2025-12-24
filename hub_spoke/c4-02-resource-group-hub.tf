# Network Resource Group
module "resource_group_network" {
  source   = "../modules/resource-group"
  name     = "rg-network-${var.location}"
  location = var.location
  tags     = local.common_tags
}

// Bastion Resource Group
module "resource_group_bastion" {
  source   = "../modules/resource-group"
  name     = "rg-bastion-${var.location}"
  location = var.location
  tags     = local.common_tags
}
