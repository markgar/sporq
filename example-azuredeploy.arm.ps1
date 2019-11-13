<#
The function "Get-Template" is required
This is where you define your ARM template in PowerShell objects

This function is called in the YAML pipeline to export arm json and run tests.
If the tests are successful, then the arm json can be added to a build artifact.
#>

function Get-Template {
    Param(
        [parameter(Mandatory = $true)] [string] $TemplateOutputPath,
        [parameter(Mandatory = $true)] [string] $EnvironmentName
    )
    Write-Host "Generating Template..."

    # Declare your common properties
    $commonProperties = Get-CommonProperties
    $commonProperties.EnvironmentName = $EnvironmentName
    $commonProperties.ApplicationCode = "q4k"

    # Grab an empty base template
    $baseTemplate = Get-BaseTemplate
    #Write-Host $baseTemplate
    # Declare some infrastructure

    #region Key Vault
    $keyVault = Get-KeyVaultTemplateFragment -CommonProperties $commonProperties -Location "centralus" 
    $baseTemplate.resources += $keyVault
    #endregion

    #region Storage Acount
    $myStorageAccount = Get-StorageTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -ExceptionGuid "f354adb1-429c-4c83-b6bd-de6012358b33" `
        -StorageAccessTier "Standard_LRS" `
        -StorageTier "Standard"
    $baseTemplate.resources += $myStorageAccount
    
    $storageKeyVaultSecret = Get-KeyVaultSecretTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVaultFragmentObject $keyVault `
        -KeyOwningObject $myStorageAccount
    $baseTemplate.resources += $storageKeyVaultSecret
    #endregion

    # region Cosmos DB
    $myCosmosDB = Get-CosmosTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $myCosmosDB

    $cosmosKeyVaultSecret = Get-KeyVaultSecretTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVaultFragmentObject $keyVault `
        -KeyOwningObject $myCosmosDB

    $baseTemplate.resources += $cosmosKeyVaultSecret
    # endregion

    # region App Services
    $webTierASP = Get-AppServicePlanTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -AppServicePlanSKU "S1"
    $baseTemplate.resources += $webTierASP

    
    $webTierWebUi = Get-AppServiceWebSiteTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -UniqueNamePhrase "web" `
        -ASPFragmentObject $webTierASP
    $baseTemplate.resources += $webTierWebUi

    $webTierApi = Get-AppServiceWebSiteTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -UniqueNamePhrase "api" `
        -ASPFragmentObject $webTierASP
    $baseTemplate.resources += $webTierApi
    # endregion

    # region App Insights
    $appInsights = Get-AppInsightsTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $appInsights
    # endregion
    
    # region Search
    $mySearchService = Get-SearchTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -ReplicaCount 1 `
        -PartitionCount 1 `
        -Sku "standard"
    $baseTemplate.resources += $mySearchService

    $searchKeyVaultSecret = Get-KeyVaultSecretTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVaultFragmentObject $keyVault `
        -KeyOwningObject $mySearchService
    $baseTemplate.resources += $searchKeyVaultSecret
    # endregion

    # region Event Hub
    $eventHubNamespace = Get-EventHubNamespaceTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $eventHubNamespace

    $eventHubNamespaceAuthorizationRule = Get-EventHubNamespaceAuthorizationRuleTemplateFragement `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -EventHubNamespaceObject $eventHubNamespace
    $baseTemplate.resources += $eventHubNamespaceAuthorizationRule

    $namespaceKeyVaultSecret = Get-KeyVaultSecretTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVaultFragmentObject $keyVault `
        -KeyOwningObject $eventHubNamespaceAuthorizationRule
    $baseTemplate.resources += $namespaceKeyVaultSecret

    $eventHub = Get-EventHubTemplateFragment `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -EventHubNamespaceFragmentObject $eventHubNamespace
    $baseTemplate.resources += $eventHub
    # endregion

    # convert the template object to a json string
    $templateJson = $baseTemplate | ConvertTo-Json -Depth 10

    # write the json string out to file
    $templateJson | Out-File -FilePath $TemplateOutputPath
}

#region Bloilerplate Code
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