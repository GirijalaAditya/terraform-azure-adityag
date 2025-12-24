module "vm_dns" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-dns"
  resource_group_name = module.resource_group_dns.resource_group_name
  location            = module.resource_group_dns.resource_group_location
  vm_subnet_id        = azurerm_subnet.subnet_dns_workloads.id
  tags                = local.common_tags
}