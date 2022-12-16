resource "azurerm_sql_server" "app_DB_server"{
    name = "app-db-server1256"
    resource_group_name = var.resourceGroup
    location = var.location
    version = "12.0"
    administrator_login          = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "app-DB" {
  name = "app-db"
  resource_group_name = var.resourceGroup
  location = var.location
  server_name = azurerm_sql_server.app_DB_server.name
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  subnet_id           = module.virtual-network.subnet1-id
}