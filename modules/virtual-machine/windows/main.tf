// Azure Public IP
resource "azurerm_public_ip" "pip" {
  count                = var.public_ip_required ? 1 : 0
  name                 = "pip-${var.vm_name}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  allocation_method    = "Static"
  sku                  = "Standard"
  sku_tier             = "Regional"
  ip_version           = "IPv4"
  zones                = ["Zone-Redundant"]
  ddos_protection_mode = "VirtualNetworkInherited"
  tags                 = var.tags
}

// Azure Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig-nic"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_required ? azurerm_public_ip.pip[0].id : null
  }
}

// Azure Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                       = var.vm_name
  computer_name              = var.computer_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  size                       = var.vm_size
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  network_interface_ids      = [azurerm_network_interface.nic.id]
  allow_extension_operations = true
  patch_mode                 = "AutomaticByPlatform"
  priority                   = "Regular"
  tags                       = var.tags

  custom_data = var.install_script ? filebase64("scripts/install.ps1") : null

  os_disk {
    name                 = "osdisk-${var.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

# // Azure Virtual Machine Extension
# resource "azurerm_virtual_machine_extension" "cloudinit" {
#   name                 = "cloudinit"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"
#   settings             = <<SETTINGS
#     {
#         "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp modules/virtual-machine/windows/scripts/install.ps1 c:/azuredata/install.ps1; c:/azuredata/install.ps1\""
#     }
#     SETTINGS
# }
