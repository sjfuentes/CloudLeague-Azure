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
  source = "../../modules/network"
  location = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on = [azurerm_resource_group.cloudLeagueResourceGroup]
  #subnet_id = module.db.subnet_id
}

 module "db" {
  source = "../../modules/db"
  location = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  subnet_id = module.db.subnet_id
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup, module.virtual-network
  ]
}


