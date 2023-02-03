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
git push
```
