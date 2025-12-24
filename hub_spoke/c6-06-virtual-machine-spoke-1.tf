module "vm_spoke_1" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-spoke-1"
  resource_group_name = module.resource_group_spoke_1.resource_group_name
  location            = module.resource_group_spoke_1.resource_group_location
  vm_subnet_id        = azurerm_subnet.subnet_spoke_1_workloads.id
  tags                = local.common_tags
}