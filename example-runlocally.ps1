# Always load the latest version
Remove-Module Sporq
Import-Module ./Sporq/Sporq.psd1 -Force

. ./example-azuredeploy.arm.ps1

$templatePath = "./out/azuredeploy.json"

# output to "out" directory to keep things clean
# "out" directory is excluded in .gitignore
Get-Template -TemplateOutputPath $templatePath -EnvironmentName "dev"

# Test-Template -TemplatePath $templatePath
