module "vm_spoke_2" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-spoke-2"
  resource_group_name = module.resource_group_spoke_2.resource_group_name
  location            = module.resource_group_spoke_2.resource_group_location
  vm_subnet_id        = azurerm_subnet.subnet_spoke_2_workloads.id
  tags                = local.common_tags
}