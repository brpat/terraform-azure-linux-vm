# Terraform Module for Azure Linux Virtual Machine

This Terraform module provisions an Azure Linux Virtual Machine (VM) along with an associated Network Interface and optional Azure Key Vault for SSH key management. Reusuable as an imported module in other projects. 

## Requirements

- **Terraform**: Version `>= 1.0.0`
- **AzureRM Provider**: Version `>= 3.0.0`

## Usage

To use this module, create a Terraform configuration file and include the module like so:

```hcl
module "linux_vm" {
  source                    = "git::https://github.com/brpat/terraform-azure-linux-vm.git?ref=v1.0"
  # Required variables
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


#### Optionally you can run this locally as an example started code has been provided in the /test folder. Update the test.tfvars as needed

```hcl
cd terraform-azure-linux-vm/test
terraform init
terraform plan --var-file test.tfvars
```