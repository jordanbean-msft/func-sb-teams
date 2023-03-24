resource "azurerm_key_vault" "key_vault" {
  name                = local.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "admin_access_policy" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Restore", "Backup"]
}

resource "azurerm_key_vault_access_policy" "user_assigned_managed_identity_access_policy" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_secret" "function_aad_service_principal_client_id" {
  name         = local.function_aad_service_principal_client_id_secret_name
  value        = local.function_aad_service_principal_client_id_secret_dummy_value
  key_vault_id = azurerm_key_vault.key_vault.id

  #prevents Terraform from overriting the value of the secret
  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "function_aad_service_principal_client_secret" {
  name         = local.function_aad_service_principal_client_secret_secret_name
  value        = local.function_aad_service_principal_client_secret_secret_dummy_value
  key_vault_id = azurerm_key_vault.key_vault.id

  #prevents Terraform from overriting the value of the secret
  lifecycle {
    ignore_changes = [value]
  }
}
