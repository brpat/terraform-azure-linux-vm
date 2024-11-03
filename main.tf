data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "vmrg" {
  name     = var.resource_group_name
  location = var.location
}


# Conditional creation of a new Key Vault if create_key_vault is true
resource "azurerm_key_vault" "kv" {
  count               = var.create_key_vault ? 1 : 0
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.vmrg.name
  sku_name            = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
    key_permissions    = ["Get", "List", "Create", "Delete", "Purge"]
  }
}

# Generate an SSH key if we're creating a new Key Vault
resource "tls_private_key" "ssh_key" {
  count      = var.create_key_vault ? 1 : 0
  algorithm  = "RSA"
  rsa_bits   = 4096
}

# Store SSH key in Key Vault if we're creating it
resource "azurerm_key_vault_secret" "ssh_key_secret" {
  count       = var.create_key_vault ? 1 : 0
  name        = "ssh-key"
  value       = tls_private_key.ssh_key[0].public_key_openssh
  key_vault_id = azurerm_key_vault.kv[0].id
}

# Data block to reference an existing Key Vault's SSH key
data "azurerm_key_vault" "existing_kv" {
  count               = var.create_key_vault ? 0 : 1
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.vmrg.name
}

data "azurerm_key_vault_secret" "existing_ssh_key" {
  count        = var.create_key_vault ? 0 : 1
  name         = var.ssh_key_name
  key_vault_id = data.azurerm_key_vault.existing_kv[0].id
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmrg.name

  ip_configuration {
    name                          = var.nic_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  tags = var.tags
}

# Using SSH key from the new or existing Key Vault in VM configuration
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.vmrg.name
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.create_key_vault ? tls_private_key.ssh_key[0].public_key_openssh : data.azurerm_key_vault_secret.existing_ssh_key[0].value
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  tags = var.tags
}
