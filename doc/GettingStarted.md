# Getting Started with Sporq
Getting started with **Sporq** is easy.  It is delivered as s nuget package from nuget.org so you'll need to create a reference to it so you can perform a ```nuget restore``` to retrieve the package.

You'll need to use some boilerplate code that includes conventions that make this all work.  You can find a sample of this code below.

1.	Create a directory on your local machine for a test arm template project
2.	Create a file called ```azuredeploy.arm.ps1```  This file will hold the powershell code that creates your arm template.
3.  When you open this file, VSCode should open a powershell terminal.
4. (Option 1)  Go to the powershell terminal, and run this command:
``` powershell
Install-Package -MinimumVersion 0.1.1 -MaximumVersion 0.1.1 -Destination ./packages -Source https://www.nuget.org/api/v2 -Name sporq
```
This should pull the **Sporq** package locally and unpack it into a directory called ```packages```.

4. (Option 2) If you are using sporq and are more familiar with nuget/pipelines, you may want to rely on a packages.config file. Create a ```packages.config``` file and insert the following text:

``` xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <package id="Sporq" version="0.1.1" />
</configuration>
```

Then, specify this file when you invoke ```install-package```:
``` powershell
 install-package -ConfigFile .\packages.config -Destination .\packages -name sporq -Source "https://www.nuget.org/api/v2"
```

5.	Next, let's paste this code into ```azuredeploy.arm.ps1```
``` powershell
<#
The function "Get-Template" is required
This is where you define your ARM template in PowerShell objects

This function is called in the YAML pipeline to export arm json and run tests.
If the tests are successful, then the arm json can be added to a build artifact.
#>

function Get-Template {
    Param(
        [parameter(Mandatory = $true)] [string] $TemplateOutputPath
    )

    # Declare your common properties
    $commonProperties = Get-CommonProperties
    $commonProperties.EnvironmentName = "dev"
    $commonProperties.ApplicationCode = "q4k"

    # Create an empty base template
    $baseTemplate = Get-BaseTemplate

    # Create a storage account fragment
    $aStorageAccount = Get-StorageTemplateFragment -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_RAGRS" -StorageTier "Standard"
    
    # Add it to the template
    $baseTemplate.resources += $aStorageAccount

    # Convert the template object to a json string
    $templateJson = $baseTemplate | ConvertTo-Json -Depth 10

    # Write the json string out to file
    $templateJson | Out-File -FilePath $TemplateOutputPath
}

<#
The function "Test-Template" is required
This is where you execute Pester tests

This function should not change too much.
#>
function Test-Template {
    Param(
        [parameter(Mandatory = $true)] [string] $TemplatePath
    )

    Write-Host "Testing template..."
    
    Write-Host "Installing Pester"
    Install-Module -Name Pester -Force

    Write-Host "Invoking Pester"
    # describe the location of the arm template to be tested
    # this is required in each file containing tests
    $parameters = @{ TemplatePath = $TemplatePath }

    # put that and a root location for where the tests are into the $script object
    $script = @{ Path = "."; Parameters = $parameters }
    Invoke-Pester -Script $script -OutputFile Tests.Report.xml -OutputFormat NUnitXml
}
```
7. Create a file called ```runlocally.ps1```  Paste in this code:
``` powershell
# Explicitly reference package with version
Import-Module ./packages/Sporq.0.0.4-preview/Sporq.psm1

# 'run' my arm template powershell definition script
. ./azuredeploy.arm.ps1

$templatePath = "./azuredeploy.json"

Get-Template -TemplateOutputPath $templatePath

Remove-Module Sporq
```

You should be able to run ```runlocally.ps1``` by running the command ```./runlocally.ps1``` from a powershell prompt.

It may seem strange that you need this ```runlocally.ps1``` file to execute the script and get your arm template.  You'll understand in a while why it works this way.

You may need to install the PowerShell Az module.  https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.0.0

# More Examples
Check the examples directory for additional samples.