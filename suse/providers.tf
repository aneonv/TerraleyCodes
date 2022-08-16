terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "TerraformStorageRG"
        storage_account_name = "terraformstoragebw"
        container_name       = "tfstate"
        key                  = "m5ZMX0JLrG+twQDgskvHrhlk7Ru1X0ZcYKUHmfZNNFzHW1pQNbDzQ4QbmTSAfjCfitOlG8gopq0C+AStkzw4KA=="
    }

  
}

provider "azurerm" {
  features {}
}
