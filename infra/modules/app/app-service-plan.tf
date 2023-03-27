resource "azurerm_service_plan" "app_service_plan" {
  name                       = local.app_service_plan_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  os_type                    = "Windows"
  sku_name                   = "I1v2"
  app_service_environment_id = data.azurerm_app_service_environment_v3.app_service_environment.id
}
