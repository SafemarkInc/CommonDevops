variable "AZURE_SUBSCRIPTIONID" { type = string }
variable "AZURE_CLIENTID" { type = string }
variable "AZURE_TENANTID" { type = string }
variable "AZURE_CLIENTSECRET" { type = string }

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  subscription_id = var.AZURE_SUBSCRIPTIONID
  client_id       = var.AZURE_CLIENTID
  tenant_id       = var.AZURE_TENANTID
  client_secret   = var.AZURE_CLIENTSECRET
}

module "common" {
  source   = "./.."
  CLOUD    = "us"
  LOCATION = "centralus"
}
