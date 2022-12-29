terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "~>1.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "thoughtworks-tfstate-rg"
    storage_account_name = "thoughtworkstfax2l4j1z"
    container_name       = "core-tfstate"
    key                  = "containerapps.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azapi" {}