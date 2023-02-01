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

$Env:ARM_SAS_TOKEN=$(az keyvault secret show --vault-name $keyvault --name 'TerraformBackendSasKey' --query value --output tsv)
$env:TF_VAR_AZURE_CLIENTSECRET=$(az keyvault secret show --vault-name $KeyVault --name $clientSecretName --query value --output tsv)

terraform init -backend-config='../../Terraform/backend.conf' -no-color
terraform workspace select $workspace -no-color

# For any services migrating into this DevOps system, upgrade from the previous way we did namespaces to the new one.
$OldAddressPrefix = 'module.all_resources.'
$NewAddressPrefix = 'module.common.module.all_resources.'
$TerraformState = terraform show -json | ConvertFrom-Json
$ResourcesInOldNamespace = $TerraformState.values.root_module.child_modules[0].resources |
    Where-Object {$_.address -like "$OldAddressPrefix*" }

foreach ($ResourceInOldNamespace in $ResourcesInOldNamespace) {
    $OldAddress = $ResourceInOldNamespace.address
    $NewAddress = $OldAddress.replace($OldAddressPrefix, $NewAddressPrefix)    
    Write-Output "Migrating $OldAddress to $NewAddress..."
    terraform state mv $OldAddress $NewAddress
    Write-Output "Done."
    Write-Output ""
}
