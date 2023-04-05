resource "azurerm_storage_account" "functionAppStorageAccount" {
  name                     = local.function_app_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_windows_function_app" "provisionTeamsFunctionApp" {
  name                = local.provision_teams_function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = data.azurerm_application_insights.application_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = data.azurerm_application_insights.application_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    "ServiceBusConnectionString"                 = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=${azurerm_key_vault_secret.serviceBusConnectionString.name})"
    "AzureAdClientId"                            = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=${data.azurerm_key_vault_secret.function_aad_service_principal_client_id.name})"
    "AzureAdClientSecret"                        = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=${data.azurerm_key_vault_secret.function_aad_service_principal_client_secret.name})"
    "AzureAdTenantId"                            = data.azurerm_client_config.current.tenant_id
  }
  key_vault_reference_identity_id = data.azurerm_user_assigned_identity.user_assigned_identity.id
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.user_assigned_identity.id]
  }
  storage_account_name       = azurerm_storage_account.functionAppStorageAccount.name
  storage_account_access_key = azurerm_storage_account.functionAppStorageAccount.primary_access_key
}

resource "azurerm_windows_function_app" "callbackFunctionApp" {
  name                = local.callback_function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = data.azurerm_application_insights.application_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = data.azurerm_application_insights.application_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    "ServiceBusConnectionString"                 = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=${azurerm_key_vault_secret.serviceBusConnectionString.name})"
  }
  key_vault_reference_identity_id = data.azurerm_user_assigned_identity.user_assigned_identity.id
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.user_assigned_identity.id]
  }
  storage_account_name       = azurerm_storage_account.functionAppStorageAccount.name
  storage_account_access_key = azurerm_storage_account.functionAppStorageAccount.primary_access_key
}

# resource "azurerm_monitor_diagnostic_setting" "web_app_diagnostic_settings" {
#   name                       = "logging"
#   target_resource_id         = azurerm_windows_function_app.functionApp.id
#   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
#   log {
#     category = "AppServiceHTTPLogs"
#     enabled  = true
#   }
#   log {
#     category = "AppServiceConsoleLogs"
#     enabled  = true
#   }
#   log {
#     category = "AppServiceAppLogs"
#     enabled  = true
#   }
#   log {
#     category = "AppServiceAuditLogs"
#     enabled  = true
#   }
#   log {
#     category = "AppServiceIPSecAuditLogs"
#     enabled  = true
#   }
#   log {
#     category = "AppServicePlatformLogs"
#     enabled  = true
#   }
#   metric {
#     category = "AllMetrics"
#     enabled  = true
#   }
# }
