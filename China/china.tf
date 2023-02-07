variable "AZURE_SUBSCRIPTIONID" { type = string }
variable "AZURE_CLIENTID" { type = string }
variable "AZURE_TENANTID" { type = string }
variable "AZURE_CLIENTSECRET" { type = string }

terraform {
  backend "azurerm" {
    environment = "china"
  }
}

provider "azuread" {
  environment = "china"
}

provider "azurerm" {
  features {}
  environment     = "china"
  subscription_id = var.AZURE_SUBSCRIPTIONID
  client_id       = var.AZURE_CLIENTID
  tenant_id       = var.AZURE_TENANTID
  client_secret   = var.AZURE_CLIENTSECRET
}

module "common" {
  source   = "./.."
  LOCATION = "chinaeast2"
}
