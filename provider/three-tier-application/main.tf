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
    key                  = "NMtbPjMNXpE2IeIXM6vn7G2rQT0WIghKsYIJjMBnL1VQJ65f3d+PbS1dZP1Eo8RB2eEasA2DoH60+AStK3s9XA=="
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azapi" {}

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

# module "db" {
#   source                     = "../../modules/db"
#   location                   = azurerm_resource_group.cloudLeagueResourceGroup.location
#   resourceGroup              = azurerm_resource_group.cloudLeagueResourceGroup.name
#   subnet-id                  = module.virtual-network.subnet1-id
#   container-group-ip-address = module.containers.containerGroupIpAddress
#   depends_on = [
#     azurerm_resource_group.cloudLeagueResourceGroup, module.virtual-network, module.containers
#   ]
# }

module "containerRegistry"{
  source        = "../../modules/containerRegistry"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup
  ]
}

module "containers" {
  source        = "../../modules/containers"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup,
    module.containerRegistry
  ]
}


