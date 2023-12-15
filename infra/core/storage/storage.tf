resource "azurerm_storage_account" "st" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  account_tier             = var.account_tier
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type
}
