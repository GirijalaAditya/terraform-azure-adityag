// Resource Group - Spoke 2
module "resource_group_spoke_2" {
  source   = "../modules/resource-group"
  name     = "rg-spoke-2"
  location = var.location
  tags     = local.common_tags
}