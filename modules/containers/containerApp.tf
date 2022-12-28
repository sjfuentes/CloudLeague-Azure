data "azurerm_resource_group" "example" {
  name = var.resourceGroup
}
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-aca-terraform"
  resource_group_name = var.resourceGroup
  location            = data.azurerm_resource_group.example.location

  sku               = "PerGB2018"
  retention_in_days = 90

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
  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        ingress = {
          external   = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled ? each.value.containerPort : null
        }
      }
      template = {
        containers = [
          {
            name  = "main"
            image = "${each.value.image}:${each.value.tag}"
            resources = {
              cpu    = each.value.cpu_requests
              memory = each.value.mem_requests
            }
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
