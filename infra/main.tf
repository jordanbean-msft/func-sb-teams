terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.48.0"
    }
  }
  backend "local" {

  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-webAppIac-ussc-terraform"
  #   storage_account_name = "sawebappiactfstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  #   #access_key = $env:ARM_ACCESS_KEY
  # }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
}

module "services" {
  source              = "./modules/services"
  resource_group_name = var.resource_group_name
  app                 = var.app
  region              = var.region
  environment         = var.environment
  location            = var.location
}

module "app" {
  source = "./modules/app"
  depends_on = [
    module.services
  ]
  resource_group_name                                      = var.resource_group_name
  location                                                 = var.location
  app                                                      = var.app
  region                                                   = var.region
  environment                                              = var.environment
  log_analytics_workspace_name                             = module.services.log_analytics_workspace_name
  application_insights_name                                = module.services.application_insights_name
  key_vault_name                                           = module.services.key_vault_name
  user_assigned_identity_name                              = module.services.user_assigned_identity_name
  app_service_plan_sku                                     = var.app_service_plan_sku
  function_aad_service_principal_client_id_secret_name     = module.services.function_aad_service_principal_client_id_secret_name
  function_aad_service_principal_client_secret_secret_name = module.services.function_aad_service_principal_client_secret_secret_name
}
