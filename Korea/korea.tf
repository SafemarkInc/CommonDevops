variable "AZURE_SUBSCRIPTIONID" { type = string }
variable "AZURE_CLIENTID" { type = string }
variable "AZURE_TENANTID" { type = string }
variable "AZURE_CLIENTSECRET" { type = string }

variable "STATEFILE_STORAGEACCOUNTNAME" { type = string }
variable "STATEFILE_CONTAINERNAME" { type = string }
variable "STATEFILE_KEY" { type = string }

terraform {
  backend "azurerm" {
    storage_account_name = var.STATEFILE_STORAGEACCOUNTNAME
    container_name       = var.STATEFILE_CONTAINERNAME
    key                  = var.STATEFILE_KEY
  }
}

module "all_resources" {
  source   = "../../Terraform"
  LOCATION = "koreacentral"

  AZURE_SUBSCRIPTIONID = var.AZURE_SUBSCRIPTIONID
  AZURE_CLIENTID       = var.AZURE_CLIENTID
  AZURE_TENANTID       = var.AZURE_TENANTID
  AZURE_CLIENTSECRET   = var.AZURE_CLIENTSECRET
}
