resource "azurerm_container_registry" "cloud-league-cr" {
  name                = "cloudleaguecr"
  resource_group_name = var.resourceGroup
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

data "azurerm_container_registry" "data-cr" {
  name                = azurerm_container_registry.cloud-league-cr.name
  resource_group_name = var.resourceGroup
}

resource "azurerm_container_group" "containerGroup" {
  name                = "cl-container-group"
  location            = var.location
  resource_group_name = var.resourceGroup
  ip_address_type     = "Public"
  os_type             = "Linux"
  dns_name_label      = "cloud-league"

  container {
    name   = "cloud-league-app"
    image  = "cloudleaguecr.azurecr.io/node-app"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
      "DB_user"     = "4dm1n157r470r"
      "DB_password" = "4-v3ry-53cr37-p455w0rd"
      "DB_server"   = "app-db-server1256.database.windows.net"
      "DB_name"     = "app-db"
    }


    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.data-cr.login_server
    username = data.azurerm_container_registry.data-cr.admin_username
    password = data.azurerm_container_registry.data-cr.admin_password
  }

}
