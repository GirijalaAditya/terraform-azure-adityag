// Resource Group - AD
module "resource_group_dns" {
  source   = "../modules/resource-group"
  name     = "rg-dns"
  location = var.location
  tags     = local.common_tags
}

// Resource Group - Private DNS
module "resource_group_private_dns" {
  source   = "../modules/resource-group"
  name     = "rg-private-dns"
  location = var.location
  tags     = local.common_tags
}