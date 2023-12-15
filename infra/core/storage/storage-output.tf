output "STORAGE_ACCOUNT_DETAILS" {
  sensitive = true
  value = {
    primary_access_key        = azurerm_storage_account.st.primary_access_key
    primary_connection_string = azurerm_storage_account.st.primary_connection_string
    name                      = azurerm_storage_account.st.name
    id                        = azurerm_storage_account.st.id
  }
}
