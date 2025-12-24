module "resource_group_hub_region3" {
  source   = "../modules/resource-group"
  name     = "rg-hub-${var.region3}"
  location = var.region3
  tags     = local.common_tags
}