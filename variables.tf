variable "vm_name" {
  description = "Name of the virtual machine."
  type        = string
}

variable "location" {
  description = "Location for the virtual machine."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the VM will be created."
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface."
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The private IP allocation method for the network interface (e.g., 'Dynamic' or 'Static')."
  type        = string
  default     = "Dynamic"
}

variable "subnet_id" {
  description = "The subnet ID where the network interface will be attached."
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM."
  type        = string
}

variable "os_disk_type" {
  description = "Type of OS disk (e.g., Standard_LRS or Premium_LRS)."
  type        = string
}

variable "os_disk_size" {
  description = "Size of OS disk in GB."
  type        = number
  default     = 30
}


variable "create_key_vault" {
  description = "Boolean to determine whether to create a new Key Vault or use an existing one."
  type        = bool
  default     = false
}

variable "key_vault_name" {
  description = "The name of the Key Vault. If creating a new Key Vault, this will be the name used."
  type        = string
}

variable "key_vault_resource_group" {
  description = "Resource group of the existing Key Vault, required if create_key_vault is false."
  type        = string
  default     = ""
}

variable "ssh_key_name" {
  description = "The name of the SSH key secret in the Key Vault, required if create_key_vault is false."
  type        = string
  default     = "ssh-key"
}


variable "tags" {
  description = "Tags to be applied to the VM."
  type        = map(string)
  default     = {}
}


