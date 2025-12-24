// Shared Resource Group - Region 1
module "resource_group_region2" {
  source   = "../modules/resource-group"
  name     = "rg-shared-${var.region2}"
  location = var.region2
  tags     = local.common_tags
}

# On-Prem Resource Group - Region 1
module "resource_group_onprem_region2" {
  source   = "../modules/resource-group"
  name     = "rg-onprem-${var.region2}"
  location = var.region2
  tags     = local.common_tags
}