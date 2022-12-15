terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features{}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "cloudLeagueResourceGroup" {
  name = var.resourceGroup
  location = var.location
}

module "virtual-network" {
  source = "../../modules/virtualNetwork"
  location = var.location
}

# module "db" {
#   source = "../../modules/db"
#   location = var.location
# }


