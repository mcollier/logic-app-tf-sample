locals {

}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

}

module "log-analytics" {
  source              = "./core/monitor/log-analytics"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = var.log_analytics_workspace_name
  location            = var.location
  tags                = {}
}

module "app-insights" {
  source                     = "./core/monitor/application-insights"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  tags                       = {}
  application_insights_name  = var.application_insights_name
  log_analytics_workspace_id = module.log-analytics.LOGANALYTICS_WORKSPACE_ID
}

module "storage-logic-app" {
  source              = "./core/storage"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = var.logic_app_storage_account_name
  tags                = {}
}


module "storage-notifications" {
  source              = "./core/storage"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = var.notification_storage_account_name
  tags                = {}
}

resource "azurerm_storage_queue" "queue-notifications" {
  name                 = var.notification_queue_name
  storage_account_name = module.storage-notifications.STORAGE_ACCOUNT_DETAILS.name
}

module "plan" {
  source                = "./core/host/app-service"
  app_service_plan_name = var.logic_app_plan_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  tags                  = {}
}

module "logicapp" {
  source                         = "./core/host/logic-app"
  location                       = var.location
  resource_group_name            = azurerm_resource_group.rg.name
  app_service_plan_id            = module.plan.APP_SERVICE_PLAN_ID
  storage_account_name           = module.storage-logic-app.STORAGE_ACCOUNT_DETAILS.name
  storage_account_access_key     = module.storage-logic-app.STORAGE_ACCOUNT_DETAILS.primary_access_key
  logic_app_name                 = var.logic_app_name
  app_insights_connection_string = module.app-insights.APPLICATIONINSIGHTS_CONNECTION_STRING
  app_settings = {
    notification_queue_connection_string = module.storage-notifications.STORAGE_ACCOUNT_DETAILS.primary_connection_string
    WORKFLOWS_RESOURCE_GROUP_NAME        = var.resource_group_name
    WORKFLOWS_SUBSCRIPTION_ID            = data.azurerm_client_config.current.subscription_id
    WORKFLOWS_LOCATION_NAME              = var.location
  }
  tags = {}
}

# NOTE: The Terraform azurerm_api_connection seems to create a "v1" API connection, which is not what is needed
#       for the Logic App. The Logic App needs a "v2" API connection. The Terraform azapi_resource resource
#       is used to create the "v2" API connection.
# data "azurerm_managed_api" "office-api" {
#   name     = "office365"
#   location = var.location
# }

# resource "azurerm_api_connection" "office_api_conn" {
#   name                = "office365"
#   resource_group_name = azurerm_resource_group.rg.name
#   managed_api_id      = data.azurerm_managed_api.office-api.id
#   display_name        = "office365"
# }

# NOTE: Unable to get this working yet.  Need to manually created the connection in the portal. :(
# resource "azapi_resource" "office365_connection" {
#   name      = "office365_connection"
#   location  = var.location
#   type      = "Microsoft.Web/connections@2016-06-01"
#   parent_id = azurerm_resource_group.rg.id
#   body = jsonencode({
#     properties = {
#       displayName = "office365"
#       api = {
#         name        = "office365",
#         displayName = "Office 365 Outlook",
#         id          = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/office365"
#         type        = "Microsoft.Web/locations/managedApis"
#       }
#     }
#   })
# }

# resource "azapi_resource" "office365_access_policy" {
#   name     = "office365_connection_access_policy"
#   location = var.location
#   type     = "Microsoft.Web/connections/accessPolicies@2016-06-01"
#   body = jsonencode({
#     properties = {
#       principal = {
#         type = "ActiveDirectory"
#         identity = {
#           tenantId    = data.azurerm_client_config.current.tenant_id
#           principalId = module.logicapp.IDENTITY
#         }
#       }
#   } })
# }
