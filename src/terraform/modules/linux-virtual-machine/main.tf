# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_resource_group" "vm_resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "linux_vm" {
  name                = "${var.name}_NIC"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name}_IPCONFIG"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "tls_private_key" "admin_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
data "azurerm_key_vault" "rg_vault" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}
resource "random_password" "vm_admin_password" {
  length      = 12
  upper       = true
  lower       = true
  numeric     = true
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.name
  computer_name       = substr(var.name, 0, 14) # computer_name can only be 15 characters maximum
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  //admin_password                  = random_password.vm_admin_password.result
  disable_password_authentication = var.disable_pw_auth

  network_interface_ids = [
    azurerm_network_interface.linux_vm.id
  ]

  admin_ssh_key { // Can I pass this in somehow
    username   = var.admin_username
    public_key = tls_private_key.admin_ssh_key.public_key_openssh //file(var.admin_ssh_pubkey_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
  count        = var.disable_pw_auth ? 0 : 1
  key_vault_id = data.azurerm_key_vault.rg_vault.id
  name         = "${var.name}-admin-password"
  value        = random_password.vm_admin_password.result
}

resource "azurerm_key_vault_secret" "vm_private_key" {
  count        = var.disable_pw_auth ? 1 : 0
  key_vault_id = data.azurerm_key_vault.rg_vault.id
  name         = "${var.name}-private-key"
  value        = tls_private_key.admin_ssh_key.private_key_openssh
}
