resource "azurerm_container_registry" "acr" {
  name                = "CloudLeagueCR"
  resource_group_name = var.resourceGroup
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

data "azurerm_container_registry" "example" {
  name                = azurerm_container_registry.acr.name
  resource_group_name = var.resourceGroup
}
resource "azurerm_container_group" "containerGroup" {
  name                = "containerGroup"
  location            = var.location
  resource_group_name = var.resourceGroup
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "cloudleaguecr.azurecr.io/nginx-demo"
    cpu    = "0.5"
    memory = "1.5"


    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server = data.azurerm_container_registry.example.login_server
    username = data.azurerm_container_registry.example.admin_username
    password = data.azurerm_container_registry.example.admin_password
  }

}
/*
  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}*/