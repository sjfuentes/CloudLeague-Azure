resource "azurerm_sql_server" "app_DB_server"{
    name = "app-db-server1256"
    resource_group_name = "1-55a4b655-playground-sandbox"
    location = var.location
    version = "12.0"
    administrator_login          = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "app-DB" {
  name = "app-db"
  resource_group_name = "1-80cab9fc-playground-sandbox"
  location = var.location
  server_name = azurerm_sql_server.app_DB_server.name
}