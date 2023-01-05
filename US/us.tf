variable "AZURE_SUBSCRIPTIONID" { type = string }
variable "AZURE_CLIENTID" { type = string }
variable "AZURE_TENANTID" { type = string }
variable "AZURE_CLIENTSECRET" { type = string }

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  subscription_id = var.AZURE_SUBSCRIPTIONID
  client_id       = var.AZURE_CLIENTID
  tenant_id       = var.AZURE_TENANTID
  client_secret   = var.AZURE_CLIENTSECRET
}

module "all_resources" {
  source   = "../../Terraform"
  LOCATION = "centralus"
}
