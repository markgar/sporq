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
    $commonProperties = Get-SpqCommonProperties
    $commonProperties.EnvironmentName = $EnvironmentName
    $commonProperties.ApplicationCode = "h9x"

    # Grab an empty base template
    $baseTemplate = Get-SpqBaseTemplate
    #Write-Host $baseTemplate
    # Declare some infrastructure

    #region Key Vault
    $keyVault = Get-SpqKeyVault -CommonProperties $commonProperties -Location "centralus" 
    $baseTemplate.resources += $keyVault
    #endregion

    #region Storage Acount
    $myStorageAccount = Get-SpqStorageAccount `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -ExceptionGuid "f354adb1-429c-4c83-b6bd-de6012358b33" `
        -StorageAccessTier "Standard_LRS" `
        -StorageTier "Standard"
    $baseTemplate.resources += $myStorageAccount
    
    $storageKeyVaultSecret = Get-SpqKeyVaultSecret `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVault $keyVault `
        -KeyOwningObject $myStorageAccount
    $baseTemplate.resources += $storageKeyVaultSecret
    #endregion

    # region Cosmos DB
    $myCosmosDB = Get-SpqCosmosDbAccount `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $myCosmosDB

    $cosmosKeyVaultSecret = Get-SpqKeyVaultSecret `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVault $keyVault `
        -KeyOwningObject $myCosmosDB

    $baseTemplate.resources += $cosmosKeyVaultSecret
    # endregion

    # region App Services
    $webTierASP = Get-SpqAppServicePlan `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -AppServicePlanSKU "S1"
    $baseTemplate.resources += $webTierASP

    
    $webTierWebUi = Get-SpqAppServiceWebSite `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -UniqueNamePhrase "web" `
        -AppServicePlan $webTierASP
    $baseTemplate.resources += $webTierWebUi

    $webTierApi = Get-SpqAppServiceWebSite `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -UniqueNamePhrase "api" `
        -AppServicePlan $webTierASP
    $baseTemplate.resources += $webTierApi
    # endregion

    # region App Insights
    $appInsights = Get-SpqAppInsights `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $appInsights
    # endregion
    
    # region Search
    $mySearchService = Get-SpqSearch `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -ReplicaCount 1 `
        -PartitionCount 1 `
        -Sku "standard"
    $baseTemplate.resources += $mySearchService

    $searchKeyVaultSecret = Get-SpqKeyVaultSecret `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVault $keyVault `
        -KeyOwningObject $mySearchService
    $baseTemplate.resources += $searchKeyVaultSecret
    # endregion

    # region Event Hub
    $eventHubNamespace = Get-SpqEventHubNamespace `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $eventHubNamespace

    $eventHubNamespaceAuthorizationRule = Get-SpqEventHubNamespaceAuthorizationRule `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -EventHubNamespace $eventHubNamespace
    $baseTemplate.resources += $eventHubNamespaceAuthorizationRule

    $namespaceKeyVaultSecret = Get-SpqKeyVaultSecret `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -KeyVault $keyVault `
        -KeyOwningObject $eventHubNamespaceAuthorizationRule
    $baseTemplate.resources += $namespaceKeyVaultSecret

    $eventHub = Get-SpqEventHub `
        -CommonProperties $commonProperties `
        -Location "centralus" `
        -EventHubNamespace $eventHubNamespace
    $baseTemplate.resources += $eventHub
    # endregion

    $publicIp = Get-SpqPublicIpAddress `
        -CommonProperties $commonProperties `
        -Location "centralus"
    $baseTemplate.resources += $publicIp

    $networkInterface = Get-SpqNetworkInterface `
        -CommonProperties $commonProperties `
        -Location "westus" `
        -VNetResourceGroupName "avm" `
        -VnetName "avm-vnet" `
        -SubnetName "default" `
        -PublicIP $publicIp
    $baseTemplate.resources += $networkInterface

    $virtualMachine = Get-SpqVirtualMachine `
        -CommonProperties $commonProperties `
        -Location "westus" `
        -VMSize "Standard_A2_v2" `
        -AdminUserName "mgarner-admin" `
        -AdminPwd "Password1!" `
        -NetworkInterface $networkInterface
    $baseTemplate.resources += $virtualMachine

    $consumptionASP = Get-SpqAppServicePlanConsumption -CommonProperties $commonProperties -Location "centralus"
    $baseTemplate.resources += $consumptionASP

    $functionApp = Get-SpqAppServiceFunctionApp -CommonProperties $commonProperties -Location "centralus" -AppServicePlan $consumptionASP -StorageAccount $myStorageAccount
    $baseTemplate.resources += $functionApp

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