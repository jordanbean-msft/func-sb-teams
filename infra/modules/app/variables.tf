variable "resource_group_name" {}
variable "location" {}
variable "app" {}
variable "region" {}
variable "environment" {}
variable "log_analytics_workspace_name" {}
variable "application_insights_name" {}
variable "key_vault_name" {}
variable "user_assigned_identity_name" {}
variable "app_service_environment_resource_group_name" {}
variable "app_service_environment_name" {}
variable "function_aad_service_principal_client_id_secret_name" {}
variable "function_aad_service_principal_client_secret_secret_name" {}

resource "random_id" "storage_account" {
  byte_length = 8
}

locals {
  app_service_plan_name                         = "asp-${var.app}-${var.region}-${var.environment}"
  provision_teams_function_app_name             = "func-provision-teams-${var.app}-${var.region}-${var.environment}"
  callback_function_app_name                    = "func-callback-${var.app}-${var.region}-${var.environment}"
  function_app_storage_account_name             = "sa${lower(random_id.storage_account.hex)}"
  service_bus_namespace_name                    = "sb-${var.app}-${var.region}-${var.environment}"
  provision_teams_service_bus_topic_name        = "provision-teams"
  callback_service_bus_topic_name               = "callback"
  service_bus_connection_string_secret_name     = "service-bus-connection-string"
  provision_teams_service_bus_subscription_name = "provision-teams-subscription"
  callback_service_bus_subscription_name        = "callback-subscription"
}
