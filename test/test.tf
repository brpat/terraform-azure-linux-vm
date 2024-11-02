module "linux_vm" {
  source                       = "../"
  vm_name                      = var.vm_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  subnet_id                    = var.subnet_id
  vm_size                      = var.vm_size
  admin_username               = var.admin_username
  os_disk_type                 = var.os_disk_type
  os_disk_size                 = var.os_disk_size
  tags                         = var.tags

  # Network interface configuration
  nic_name                      = var.nic_name
  private_ip_address_allocation = var.private_ip_address_allocation

  # Key Vault configuration
  create_key_vault          = var.create_key_vault
  key_vault_name            = var.key_vault_name
  key_vault_resource_group  = var.key_vault_resource_group
  ssh_key_name              = var.ssh_key_name
}
