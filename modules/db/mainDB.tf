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
  depends_on = [azurerm_sql_server.app_DB_server]
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  subnet_id           = var.subnet-id
}

resource "azurerm_sql_firewall_rule" "public-ip" {
  name                = "FirewallRule1-public-ip"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  start_ip_address    = var.container-group-ip-address
  end_ip_address      = var.container-group-ip-address
}

resource "azurerm_sql_firewall_rule" "subnet-ip" {
  name                = "FirewallRule1-subnet"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  start_ip_address    = "20.75.134.75"
  end_ip_address      = "20.75.134.75"
}
resource "azurerm_sql_firewall_rule" "local-ip" {
  name                = "FirewallRule-mylocal"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  start_ip_address    = "157.100.135.241"
  end_ip_address      = "157.100.135.241"
}