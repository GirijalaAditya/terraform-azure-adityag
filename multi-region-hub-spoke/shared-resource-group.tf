module "resource_group_private_dns" {
  source   = "../modules/resource-group"
  name     = "rg-shared-private-dns"
  location = var.region1
  tags     = local.common_tags
}