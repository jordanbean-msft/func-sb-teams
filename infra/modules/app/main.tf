data "azurerm_client_config" "current" {}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "function_aad_service_principal_client_id" {
  name         = var.function_aad_service_principal_client_id_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "function_aad_service_principal_client_secret" {
  name         = var.function_aad_service_principal_client_secret_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_app_service_environment_v3" "app_service_environment" {
  name                = var.app_service_environment_name
  resource_group_name = var.app_service_environment_resource_group_name
}
