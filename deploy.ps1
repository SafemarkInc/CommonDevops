$ErrorActionPreference = "Stop"

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

if ($NULL -eq $Env:RELEASE_ENVIRONMENTNAME) {
    throw 'Please specify an environment (i.e. ''China dev'')'
}

$Cloud = $Env:RELEASE_ENVIRONMENTNAME.Split()[0]

#If you get an error here, try changing the version of the Install Terraform task
$ExpectedTerraformVersion = 'Terraform v1.3.6'
$ActualTerraformVersion = $(terraform version show).Split('\n')[0]
if ($ExpectedTerraformVersion -ne $ActualTerraformVersion) { throw 'Expected ' + $ExpectedTerraformVersion + ', got ' + $ActualTerraformVersion }

$Env:ARM_SUBSCRIPTION_ID=$(az account show) | ConvertFrom-Json | Select-Object -ExpandProperty id
Write-Output "$(Get-TimeStamp) Subscription ID is $($Env:ARM_SUBSCRIPTION_ID)"
Write-Output ''

Write-Output "$(Get-TimeStamp) Setting up Terraform environment variables..."
$Env:ARM_CLIENT_ID=$Env:AZURE_SERVICEPRINCIPAL_USER
$Env:ARM_CLIENT_SECRET=$Env:AZURE_SERVICEPRINCIPAL_PASSWORD
$Env:ARM_TENANT_ID=$Env:AZURE_SERVICEPRINCIPAL_TENANTID
$TerraformEnvironment = $Env:RELEASE_ENVIRONMENTNAME.Split()[1]
Write-Output "$(Get-TimeStamp) Done. Initializing Terraform and switching to $TerraformEnvironment workspace..."
Set-Location ($PSScriptRoot + '/CommonDevops/' + $Cloud)
./terraform_init.ps1 $TerraformEnvironment

Write-Output "$(Get-TimeStamp) Done. Applying Terraform..."
terraform apply -auto-approve -no-color
if (!$?) { throw 'terraform apply failed' }
Write-Output "$(Get-TimeStamp) Done."
Write-Output ''

$TerraformState = terraform show -json | ConvertFrom-Json
$AllResources = $TerraformState.values.root_module.child_modules[0].child_modules.resources
Set-Location ../..

$TerraformWebapp = $AllResources | Where-Object {$_.address -eq $WebappName} | Select-Object -ExpandProperty values
$deploymentFile = Get-ChildItem *.zip -Name
Write-Output "$(Get-TimeStamp) Deploying $deploymentFile to $($TerraformWebapp.name) ..."
az webapp deployment source config-zip -g $TerraformWebapp.resource_group_name --n $TerraformWebapp.name --src $deploymentFile
if ($LASTEXITCODE -ne 0) { throw }
Write-Output "$(Get-TimeStamp) Done."

$TerraformResourceGroup = $AllResources | Where-Object {$_.address -eq $ResourcegroupName} | Select-Object -ExpandProperty values
Write-Output "$(Get-TimeStamp) Updating labels for $($TerraformResourceGroup.name) ..."
$deploymentDate = $(Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
az tag update --resource-id $TerraformResourceGroup.Id --operation merge --tags DevopsBuild=$BuildNumber BuildDate=$BuildDate DeploymentDateUTC=$deploymentDate DevopsDeployment=$env:RELEASE_RELEASENAME
Write-Output "$(Get-TimeStamp) Done."
