output "user" {
  value = azurerm_sql_server.app_DB_server.administrator_login
}

output "password" {
  value = azurerm_sql_server.app_DB_server.administrator_login_password
}

output "server" {
  value = azurerm_sql_server.app_DB_server.fully_qualified_domain_name
}


output "db-name" {
  value = azurerm_sql_database.app-DB.name
}