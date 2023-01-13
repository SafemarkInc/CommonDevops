variable "LOCATION" { type = string }

locals {
  parsed_workspace              = element(split("_", terraform.workspace), 1)
  shortened_location            = (var.LOCATION == "koreacentral" ? "korea" : var.LOCATION)
  smidshared_resourcegroup_name = "rg-smidentity-${local.parsed_workspace}-${local.shortened_location}"
  smidshared_keyvault_name = lookup({
    "chinaeast2" : "kv-smidshared-${local.parsed_workspace}",
    "centralus" : "kv-smidshared-${local.parsed_workspace}",
  }, var.LOCATION, "kv-smidshared-${local.parsed_workspace}-${local.shortened_location}")
}

module "all_resources" {
  source                        = "../Terraform"
  LOCATION                      = var.LOCATION
  SMIDSHARED_RESOURCEGROUP_NAME = local.smidshared_resourcegroup_name
  SMIDSHARED_KEYVAULT_NAME      = local.smidshared_keyvault_name
}
