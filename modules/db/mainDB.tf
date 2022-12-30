data "azurerm_key_vault_secret" "user" {
  name         = "db-user"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/key123823"
}

data "azurerm_key_vault_secret" "password" {
  name         = "db-password"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/key123823"
}

resource "azurerm_sql_server" "app_DB_server" {
  name                         = "app-db-server1256"
  resource_group_name          = var.resourceGroup
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.user.value
  administrator_login_password = data.azurerm_key_vault_secret.password.value
}

resource "azurerm_sql_database" "app-DB" {
  name                = "app-db"
  resource_group_name = var.resourceGroup
  location            = var.location
  server_name         = azurerm_sql_server.app_DB_server.name
  depends_on          = [azurerm_sql_server.app_DB_server]
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
  start_ip_address    = "20.241.189.228"
  end_ip_address      = "20.241.189.228"
}
resource "azurerm_sql_firewall_rule" "local-ip" {
  name                = "FirewallRule-mylocal"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  start_ip_address    = "157.100.135.241"
  end_ip_address      = "157.100.135.241"
}