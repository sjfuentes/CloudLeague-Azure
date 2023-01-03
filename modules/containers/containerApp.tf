data "azurerm_resource_group" "example" {
  name = var.resourceGroup
}

data "azurerm_container_registry" "example" {
  name                = "cloudLeagueCR"
  resource_group_name = var.resourceGroup
}

data "azurerm_sql_server" "sql-server" {
  name                = "app-db-server1256"
  resource_group_name = var.resourceGroup
}

data "azurerm_sql_database" "sql-db" {
  name                = "app-db"
  server_name         = "app-db-server1256"
  resource_group_name = var.resourceGroup
}

data "azurerm_key_vault_secret" "user" {
  name         = "db-user"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/cloud-league"
}

data "azurerm_key_vault_secret" "password" {
  name         = "db-password"
  key_vault_id = "/subscriptions/42675650-b369-4b31-8667-dc009a8da13f/resourceGroups/cloudLeagueResourceGroup/providers/Microsoft.KeyVault/vaults/cloud-league"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-aca-terraform"
  resource_group_name = var.resourceGroup
  location            = data.azurerm_resource_group.example.location

  sku               = "PerGB2018"
  retention_in_days = 90

}

resource "azurerm_user_assigned_identity" "containerapp" {
  location            = data.azurerm_resource_group.example.location
  name                = "containerappmi"
  resource_group_name = var.resourceGroup
}
 
resource "azurerm_role_assignment" "containerapp" {
  scope                = data.azurerm_resource_group.example.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.containerapp.principal_id
  depends_on = [
    azurerm_user_assigned_identity.containerapp
  ]
}

resource "azapi_resource" "aca_env" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id = data.azurerm_resource_group.example.id
  location  = data.azurerm_resource_group.example.location
  name      = "env-terraform"

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.law.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
        }
      }
    }
  })
}

resource "azapi_resource" "aca" {
  for_each = { for ca in var.container_apps : ca.name => ca }

  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = data.azurerm_resource_group.example.id
  location  = data.azurerm_resource_group.example.location
  name      = each.value.name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.containerapp.id]
  }


  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        ingress = {
          external   = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled ? each.value.containerPort : null
        },
         registries = [
          {
            server = data.azurerm_container_registry.example.login_server,
            identity = azurerm_user_assigned_identity.containerapp.id
          }
        ],
        secrets= [
        {
                name= "dbuser"
                value= data.azurerm_key_vault_secret.user.value
              },
              {
                name= "dbpassword"
                value= data.azurerm_key_vault_secret.password.value
              },
              {
                name= "dbserver"
                value= data.azurerm_sql_server.sql-server.fqdn
              },
              {
                name= "dbname"
                value= data.azurerm_sql_database.sql-db.name
              }
      ]
      }
      template = {
        containers = [
          {
            name  = "main"
            image = "${each.value.image}:${each.value.tag}"
            resources = {
              cpu    = each.value.cpu_requests
              memory = each.value.mem_requests
            },
            env= [
              {
                name= "DB_user"
                secretRef= "dbuser"
                # value= data.azurerm_sql_server.sql-server.administrator_login
              },
              {
                name= "DB_password"
                secretRef= "dbpassword"
                # value= "4-v3ry-53cr37-p455w0rd"
              },
              {
                name= "DB_server"
                secretRef= "dbserver"
                # value= data.azurerm_sql_server.sql-server.fqdn
              },
              {
                name= "DB_name"
                secretRef= "dbname"
                # value= data.azurerm_sql_database.sql-db.name
              }
            ]
          }
        ]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
        }
      }
    }
  })
}
