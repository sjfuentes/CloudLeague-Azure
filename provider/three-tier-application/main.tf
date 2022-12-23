terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "thoughtworks-tfstate-rg"
    storage_account_name = "thoughtworkstfax2l4j1z"
    container_name       = "core-tfstate"
    key                  = var.key
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "cloudLeagueResourceGroup" {
  name     = var.resourceGroup
  location = var.location
}

module "virtual-network" {
  source        = "../../modules/network"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on    = [azurerm_resource_group.cloudLeagueResourceGroup]
}
/*
module "db" {
  source        = "../../modules/db"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  subnet-id     = module.virtual-network.subnet1-id
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup, module.virtual-network
  ]
}
*/
module "containers" {
  source        = "../../modules/containers"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup
  ]
}
/*
module "loadBalancer" {
  source                     = "../../modules/loadBalancer"
  location                   = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup              = azurerm_resource_group.cloudLeagueResourceGroup.name
  virtual-network-id         = module.virtual-network.virtualNetworkId
  container-group-ip-address = module.containers.containerGroupIpAddress
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup
  ]
}*/


