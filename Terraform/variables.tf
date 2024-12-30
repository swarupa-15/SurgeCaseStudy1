variable "rgname" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {

  type        = string
  description = "Resource Group Name"
  default     = "Central India"

}

variable "service_principal_name" {

  type        = string
  description = "Name of Service Principal"

}

variable "keyvault_name" {
  type = string
}