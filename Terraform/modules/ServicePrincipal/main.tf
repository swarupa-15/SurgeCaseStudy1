data "azuread_client_config" "current" {}

resource "azuread_application" "azapp" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]

   lifecycle {
    ignore_changes = [ owners ]
  }
}

resource "azuread_service_principal" "spn" {
  client_id                    = azuread_application.azapp.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]

  lifecycle {
    ignore_changes = [ owners ]
  }
}

resource "azuread_service_principal_password" "spnpass" {
  service_principal_id = azuread_service_principal.spn.id
}