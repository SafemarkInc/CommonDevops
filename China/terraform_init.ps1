$ErrorActionPreference = "Stop"

$env:TF_VAR_AZURE_SUBSCRIPTIONID = "e122ba82-f7ff-4be4-9fb7-d8cbf4b4a0e1"
$env:TF_VAR_AZURE_CLIENTID = "c4bda161-ca56-412c-a7d1-f1735af6d15e"
$env:TF_VAR_AZURE_TENANTID = "a0861151-54bf-435a-9068-9b12227722d8"

../_terraform_init.ps1 $args[0] 'China' 'kv-terraform-chinaeast2' 'TerraformChinaClientSecret'
