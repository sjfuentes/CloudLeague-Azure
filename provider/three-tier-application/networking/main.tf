resource "azurerm_resource_group" "cloudLeagueResourceGroup" {
  name     = var.resourceGroup
  location = var.location
}

module "virtual-network" {
  source        = "../../../modules/network"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on    = [azurerm_resource_group.cloudLeagueResourceGroup]
}

module "containerRegistry"{
  source        = "../../../modules/containerRegistry"
  location      = azurerm_resource_group.cloudLeagueResourceGroup.location
  resourceGroup = azurerm_resource_group.cloudLeagueResourceGroup.name
  depends_on = [
    azurerm_resource_group.cloudLeagueResourceGroup
  ]
}


