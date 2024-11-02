terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
    backend "azurerm" {
      resource_group_name   = "Offensive-Lab"
      storage_account_name  = "cyberlabtfstate"
      container_name        = "tfstate"
      key                   = "demo-linux-vm"
  }

}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
