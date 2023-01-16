variable "LOCATION" { type = string }

locals {
  parsed_workspace              = element(split("_", terraform.workspace), 1)
  shortened_location            = (var.LOCATION == "koreacentral" ? "korea" : var.LOCATION)
  smid_resource_suffix          = "smidentity-${local.parsed_workspace}-${local.shortened_location}"
  smidshared_resourcegroup_name = "rg-${local.smid_resource_suffix}"
  smidshared_keyvault_name = lookup({
    "chinaeast2" : "kv-smidshared-${local.parsed_workspace}",
    "centralus" : "kv-smidshared-${local.parsed_workspace}",
  }, var.LOCATION, "kv-smidshared-${local.parsed_workspace}-${local.shortened_location}")

  smid_webapp_url_ifchina    = "https://smid${local.parsed_workspace == "prod" ? "" : "-${local.parsed_workspace}"}.goroll.com.cn/"
  smid_webapp_url_ifnotchina = "https://app-${local.smid_resource_suffix}.azurewebsites.net/"
  smid_webapp_url            = (var.LOCATION == "chinaeast2" ? local.smid_webapp_url_ifchina : local.smid_webapp_url_ifnotchina)
}

module "all_resources" {
  source                        = "../Terraform"
  LOCATION                      = var.LOCATION
  SMIDSHARED_RESOURCEGROUP_NAME = local.smidshared_resourcegroup_name
  SMIDSHARED_KEYVAULT_NAME      = local.smidshared_keyvault_name
  SMID_WEBAPP_URL               = local.smid_webapp_url
}
