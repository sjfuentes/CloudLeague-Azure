data "azurerm_resource_group" "example" {
  name = var.resourceGroup
}

resource "azapi_resource" "acr" {
  type = "Microsoft.ContainerRegistry/registries@2021-09-01"
  name = "cloudLeagueCR"
  location = var.location
  parent_id = data.azurerm_resource_group.example.id
  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = true
    }
  })
}