resource "azurerm_logic_app_standard" "logic-app" {
  name                       = var.logic_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  https_only = true
  version    = "~4"


  app_settings = merge(var.app_settings, {
    FUNCTIONS_WORKER_RUNTIME              = "node"
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
  })

  site_config {
    always_on  = false
    ftps_state = "Disabled"
  }

  identity {
    type = "SystemAssigned"
  }
}
