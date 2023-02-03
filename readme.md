To use:
- Reference repo as a submodule with git
```
git submodule add https://github.com/SafemarkInc/CommonDevops.git
```
- Create a build file. In Powershell:
```
$BaselineSha = $(git rev-parse HEAD)
$CommonDevopsSha = $(git submodule status .\CommonDevops\).Split()[1]
mkdir Pipelines
$buildYmlContents = Get-Content -path ./CommonDevops/sample-build.yml -Raw
$buildYmlContents = $buildYmlContents -replace 'COMMONDEVOPS_SHA',$CommonDevopsSha
Set-Content $buildYmlContents -Path ./Pipelines/build.yml
```