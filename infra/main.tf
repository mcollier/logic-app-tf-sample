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
    OFFICE365_CONNECTION_RUNTIME_URL     = jsondecode(azurerm_resource_group_template_deployment.office365_api_connetion.output_content).connectionRuntimeUrl.value
  }
  tags = {}
}

# NOTE: The Terraform azurerm_api_connection seems to create a "v1" API connection, which is not what is needed
#       for the Logic App. The Logic App needs a "v2" API connection. Thefore, the azurerm_resource_gorup_template_deployment
#       resource is used to create the "v2" API connection and associated access policy.
#       See https://github.com/hashicorp/terraform-provider-azurerm/issues/23064.
data "local_file" "office365_arm_template" {
  filename = "${path.module}/office365-api-connection.json"
}

data "local_file" "office365_arm_template_access_policy" {
  filename = "${path.module}/office365-api-connection-access-policy.json"

}

resource "azurerm_resource_group_template_deployment" "office365_api_connetion" {
  name                = "office365_api_connetion"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"
  template_content    = data.local_file.office365_arm_template.content
  parameters_content  = jsonencode({})
}

resource "azurerm_resource_group_template_deployment" "office365_api_connection_access_policy" {
  name                = "office365_api_connection_access_policy"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"
  template_content    = data.local_file.office365_arm_template_access_policy.content
  parameters_content = jsonencode({
    "principalId" = {
      value = module.logicapp.principal_id
    },
    "tenantId" = {
      value = data.azurerm_client_config.current.tenant_id
    }
  })
}

