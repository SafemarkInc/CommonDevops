$ErrorActionPreference = "Stop"

$workspace = $args[0]
$cloud = $args[1]
$keyvault = $args[2]
$clientSecretName = $args[3]

Write-Output ('Cloud is ' + $cloud)

if ($null -eq $workspace) { $workspace = 'dev' }
if ($cloud -eq 'Korea') {
    $workspace = 'korea_' + $workspace
}

Write-Output ('Workspace is ' + $workspace)

. ..\..\Terraform\_settings.ps1
$Env:ARM_SAS_TOKEN=$(az keyvault secret show --vault-name $keyvault --name 'TerraformBackendSasKey' --query value --output tsv)
$env:TF_VAR_AZURE_CLIENTSECRET=$(az keyvault secret show --vault-name $KeyVault --name $clientSecretName --query value --output tsv)

terraform init -backend-config='../../Terraform/backend.conf' -no-color
terraform workspace select $workspace -no-color
