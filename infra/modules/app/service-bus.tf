resource "azurerm_servicebus_namespace" "serviceBusNamespace" {
  name                = local.service_bus_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "provisionTeamsServiceBusTopic" {
  name         = local.provision_teams_service_bus_topic_name
  namespace_id = azurerm_servicebus_namespace.serviceBusNamespace.id
}

resource "azurerm_servicebus_topic" "callbackServiceBusTopic" {
  name         = local.callback_service_bus_topic_name
  namespace_id = azurerm_servicebus_namespace.serviceBusNamespace.id
}

resource "azurerm_servicebus_subscription" "provisionTeamsServiceBusSubscription" {
  name               = local.provision_teams_service_bus_subscription_name
  topic_id           = azurerm_servicebus_topic.provisionTeamsServiceBusTopic.id
  max_delivery_count = 1
}

resource "azurerm_servicebus_subscription" "callbackServiceBusSubscription" {
  name               = local.callback_service_bus_subscription_name
  topic_id           = azurerm_servicebus_topic.callbackServiceBusTopic.id
  max_delivery_count = 1
}

resource "azurerm_key_vault_secret" "serviceBusConnectionString" {
  name         = local.service_bus_connection_string_secret_name
  value        = azurerm_servicebus_namespace.serviceBusNamespace.default_primary_connection_string
  key_vault_id = data.azurerm_key_vault.key_vault.id

  #prevents Terraform from overriting the value of the secret
  lifecycle {
    ignore_changes = [value]
  }
}
