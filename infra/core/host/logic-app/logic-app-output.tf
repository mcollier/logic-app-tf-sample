output "IDENTITY" {
  value     = azurerm_logic_app_standard.logic-app.identity[0].principal_id
  sensitive = true
}
