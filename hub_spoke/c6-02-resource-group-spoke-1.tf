// Resource Group - Spoke 1
module "resource_group_spoke_1" {
  source   = "../modules/resource-group"
  name     = "rg-spoke-1"
  location = var.location
  tags     = local.common_tags
}