output "service_principal_name" {
  value = azuread_service_principal.spn.display_name
  description = "Display Name of Service Principal"
}

output "service_principal_object_id" {
  
  value = azuread_service_principal.spn.object_id
  description = "Object ID of Service Principal"
}

output "service_principal_tenant_id" {
  
  value = azuread_service_principal.spn.application_tenant_id
  description = "Tenant ID of Service Principal"
}

output "service_principal_application_id" {
  
  value = azuread_service_principal.spn.client_id
  description = "Application ID of Service Principal"
}

output "client_id" {
  
  value = azuread_application.azapp.client_id
  description = "Client ID of Azure ad app"
}

output "client_secret" {
  
  value = azuread_service_principal_password.spnpass.value
  description = "client secret for Azure ad app"
}