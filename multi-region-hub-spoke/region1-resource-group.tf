module "resource_group_hub_region1" {
  source   = "../modules/resource-group"
  name     = "rg-hub-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}