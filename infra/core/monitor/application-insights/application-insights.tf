resource "azurerm_application_insights" "applicationinsights" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  workspace_id     = var.log_analytics_workspace_id
  application_type = "web"
}
