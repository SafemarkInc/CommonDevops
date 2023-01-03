$ErrorActionPreference = "Stop"

$env:TF_VAR_AZURE_SUBSCRIPTIONID = "bd767fe5-fc68-430e-b590-fdfb8da7bc2a"
$env:TF_VAR_AZURE_CLIENTID = "241af242-3f94-432d-8375-7d840425cbe2"
$env:TF_VAR_AZURE_TENANTID = "410bf229-e757-44fc-9251-5d9f0faffa14"

../_terraform_init.ps1 $args[0] 'US' 'kv-terraform-eastus' 'TerraformUsClientSecret'
