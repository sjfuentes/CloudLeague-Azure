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

data "azurerm_key_vault_secret" "example" {
  name         = "secret"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/key123823"
}

output "secret_value" {
  value     = data.azurerm_key_vault_secret.example.value
  sensitive = true
}