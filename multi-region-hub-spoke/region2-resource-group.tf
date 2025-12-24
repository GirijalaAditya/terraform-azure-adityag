module "resource_group_hub_region2" {
  source   = "../modules/resource-group"
  name     = "rg-hub-${var.region2}"
  location = var.region2
  tags     = local.common_tags
}