data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location

  lifecycle {
    ignore_changes = [ tags ]
  }
}

module "ServicePrincipal" {
  source = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_role_assignment" "rolespn" {
  
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "azurerm_key_vault_access_policy" "kv_access_pl" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = module.ServicePrincipal.service_principal_tenant_id
  object_id    = module.ServicePrincipal.service_principal_object_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore" , "Set"
  ]
}

resource "azurerm_key_vault_secret" "kvsecret" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault
  ]
}

module "AKS" {
  source = "./modules/aks"
  service_principal_name = var.service_principal_name
  client_id = module.ServicePrincipal.client_id
  client_secret = module.ServicePrincipal.client_secret
  location = var.location
  resource_group_name = var.rgname

  depends_on = [ module.ServicePrincipal ]
}