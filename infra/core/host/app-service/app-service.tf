# resource "azurerm_app_service_plan" "logic_app_plan" {
#   name                = var.app_service_plan_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   kind                = "elastic"
#   tags                = var.tags
#   sku {
#     tier = "WorkflowStandard"
#     size = "WS1"
#   }
#   zone_redundant = false
# }


resource "azurerm_service_plan" "logic_app_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = "WS1"
}
