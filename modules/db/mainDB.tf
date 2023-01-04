data "azurerm_key_vault_secret" "user" {
  name         = "db-user"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/cloud-league"
}

data "azurerm_key_vault_secret" "password" {
  name         = "db-password"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/cloud-league"
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
resource "azurerm_sql_firewall_rule" "container-ip" {
  name                = "Contanier-firewall-rule"
  resource_group_name = var.resourceGroup
  server_name         = azurerm_sql_server.app_DB_server.name
  start_ip_address    = "104.45.179.108"
  end_ip_address      = "104.45.179.108"
}