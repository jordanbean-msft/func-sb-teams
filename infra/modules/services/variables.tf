variable "resource_group_name" {}
variable "location" {}
variable "app" {}
variable "region" {}
variable "environment" {}

locals {
  log_analytics_workspace_name                                    = "la-${var.app}-${var.region}-${var.environment}"
  application_insights_name                                       = "ai-${var.app}-${var.region}-${var.environment}"
  key_vault_name                                                  = "kv-${var.app}${var.environment}"
  user_assigned_identity_name                                     = "mi-${var.app}-${var.region}-${var.environment}"
  function_aad_service_principal_client_id_secret_name            = "function-aad-service-principal-client-id"
  function_aad_service_principal_client_id_secret_dummy_value     = "dummy-value"
  function_aad_service_principal_client_secret_secret_name        = "function-aad-service-principal-client-secret"
  function_aad_service_principal_client_secret_secret_dummy_value = "dummy-value"
}
