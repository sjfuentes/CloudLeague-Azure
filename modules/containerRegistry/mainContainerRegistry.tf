resource "azurerm_container_registry" "cloud-league-cr" {
  name                = "cloudleaguecr"
  resource_group_name = var.resourceGroup
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}