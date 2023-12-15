output "APP_SERVICE_PLAN_ID" {
  value     = azurerm_service_plan.logic_app_plan.id
  sensitive = true
}
