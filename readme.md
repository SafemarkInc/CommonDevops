To use:
- Run the following commands in Powershell:
```
git submodule add https://github.com/SafemarkInc/CommonDevops.git
$BaselineSha = $(git rev-parse HEAD)
$CommonDevopsSha = $(git submodule status .\CommonDevops\).Split()[1]

mkdir Pipelines
$buildYmlContents = Get-Content -path ./CommonDevops/sample-build.yml -Raw
$buildYmlContents = $buildYmlContents -replace 'COMMONDEVOPS_SHA',$CommonDevopsSha
Set-Content $buildYmlContents -Path ./Pipelines/build.yml

git checkout -b add-common-devops
git add ./Pipelines/build.yml
git commit * -m "Added CommonDevops into this repo"
git push --set-upstream origin add-common-devops
```
- Open Pipelines/build.yml in a text editor and fill in everything that says FILL_THIS_IN.
- Rearrange the Terraform directory to look like the one in GoReporting and TemplateService.
- Add a backend.conf, similar to one of the two projects above. Make sure the information in it is correct.
- From the CommonDevops/us directory, run the following from Powershell and make sure the result looks reasonable. You will probably need to do some adjusting to your Terraform files to make them work in this new system, but you should get helpful errors to make that easy:
```
./terraform_init.ps1
terraform plan
```
- Add Git to Azure pipelines project
  - Navigate to the corresponding project in Azure Pipeines
  - Project Settings > Service Connections > New Service Connection
  - GitHub, Next
    - Grant authorization
    - Oauth Configuration: AzurePipelines
    - Authorize
    - Service connection name: github (all lowercase)
    - Save
- Manually trigger a build in Azure pipelines
- Navigate into the Job
- You will see a banner asking for permission with a button to grant permission. Use this button to grant permission.
- The build should begin. If there are any errors, fix them.