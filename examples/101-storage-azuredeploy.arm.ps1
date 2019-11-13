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
    Write-Host "Generating Template..."

    # Declare your common properties
    $commonProperties = Get-CommonProperties
    $commonProperties.EnvironmentName = "dev"
    $commonProperties.ApplicationCode = "q4k"

    # Grab an empty base template
    $baseTemplate = Get-BaseTemplate

    # Create Storage Account
    $myStorageAccount = Get-StorageTemplateFragment -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_LRS" -StorageTier "Standard"
    
    # Add to Template
    $baseTemplate.resources += $myStorageAccount
    
    # convert the template object to a json string
    $templateJson = $baseTemplate | ConvertTo-Json -Depth 10

    # write the json string out to file
    $templateJson | Out-File -FilePath $TemplateOutputPath
}

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