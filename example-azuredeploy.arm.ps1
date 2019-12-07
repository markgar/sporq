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

    $environmentName = "dev"
    $applicationCode = "kfj"

    # Grab an empty base template
    $baseTemplate = Get-SpqBaseTemplate
    #Write-Host $baseTemplate
    # Declare some infrastructure

    #region Key Vault
    # $keyVault = Get-SpqKeyVault -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus" `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $keyVault
    #endregion

    #region Storage Acount
    # $myStorageAccount = Get-SpqStorageAccount `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -ExceptionGuid "f354adb1-429c-4c83-b6bd-de6012358b33" `
    #     -StorageAccessTier "Standard_LRS" 
    # $baseTemplate.resources += $myStorageAccount
    
    # $storageKeyVaultSecret = Get-SpqKeyVaultSecret `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -KeyVault $keyVault `
    #     -KeyOwningObject $myStorageAccount
    # $baseTemplate.resources += $storageKeyVaultSecret
    #endregion

    # region Cosmos DB
    # $myCosmosDB = Get-SpqCosmosDbAccount `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $myCosmosDB

    # $cosmosKeyVaultSecret = Get-SpqKeyVaultSecret `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -KeyVault $keyVault `
    #     -KeyOwningObject $myCosmosDB
    # $baseTemplate.resources += $cosmosKeyVaultSecret
    # endregion

    # region App Services
    # $webTierASP = Get-SpqAppServicePlan `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -AppServicePlanSKU "S1"
    # $baseTemplate.resources += $webTierASP

    
    # $webTierWebUi = Get-SpqAppServiceWebSite `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -UniqueNamePhrase "web" `
    #     -AppServicePlan $webTierASP
    # $baseTemplate.resources += $webTierWebUi

    # $webTierApi = Get-SpqAppServiceWebSite `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -UniqueNamePhrase "api" `
    #     -AppServicePlan $webTierASP
    # $baseTemplate.resources += $webTierApi
    # endregion

    # region App Insights
    # $appInsights = Get-SpqAppInsights `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus"
    # $baseTemplate.resources += $appInsights

    # $logAnalytics = Get-SpqLogAnalytics `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus"
    # $baseTemplate.resources += $logAnalytics
    # endregion
    
    # region Search
    # $mySearchService = Get-SpqSearch `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -ReplicaCount 1 `
    #     -PartitionCount 1 `
    #     -Sku "standard" `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $mySearchService

    # $searchKeyVaultSecret = Get-SpqKeyVaultSecret `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -KeyVault $keyVault `
    #     -KeyOwningObject $mySearchService
    # $baseTemplate.resources += $searchKeyVaultSecret
    # endregion

    # region Event Hub
    # $eventHubNamespace = Get-SpqEventHubNamespace `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $eventHubNamespace

    # $eventHubNamespaceAuthorizationRule = Get-SpqEventHubNamespaceAuthorizationRule `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -EventHubNamespace $eventHubNamespace
    # $baseTemplate.resources += $eventHubNamespaceAuthorizationRule

    # $namespaceKeyVaultSecret = Get-SpqKeyVaultSecret `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -KeyVault $keyVault `
    #     -KeyOwningObject $eventHubNamespaceAuthorizationRule
    # $baseTemplate.resources += $namespaceKeyVaultSecret

    # $eventHub = Get-SpqEventHub `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -EventHubNamespace $eventHubNamespace
    # $baseTemplate.resources += $eventHub
    # endregion

    # $redis = Get-SpqRedis `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" `
    #     -SkuName "Standard" `
    #     -SkuFamily "C" `
    #     -SkuCapacity 1 `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $redis

    # $appConfig = Get-SpqAppConfiguration `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "centralus" 
    # $baseTemplate.resources += $appConfig

    # $publicIp = Get-SpqPublicIpAddress `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "westus" `
    #     -LogAnalyticsResourceGroupName "DefaultResourceGroup-EUS" `
    #     -LogAnalyticsWorkspaceName "DefaultWorkspace-75ebdae9-6e1c-4baa-8b2e-5576f6356a91-EUS"
    # $baseTemplate.resources += $publicIp

    # $networkInterface = Get-SpqNetworkInterface `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "westus" `
    #     -VNetResourceGroupName "avm" `
    #     -VnetName "avm-vnet" `
    #     -SubnetName "default" `
    #     -PublicIP $publicIp
    # $baseTemplate.resources += $networkInterface

    # $virtualMachine = Get-SpqVirtualMachine `
    #     -ApplicationCode $applicationCode `
    #     -EnvironmentName $environmentName `
    #     -Location "westus" `
    #     -VMSize "Standard_A2_v2" `
    #     -AdminUserName "mgarner-admin" `
    #     -AdminPwd "Password1!" `
    #     -NetworkInterface $networkInterface
    # $baseTemplate.resources += $virtualMachine

    # $consumptionASP = Get-SpqAppServicePlanConsumption -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus"
    # $baseTemplate.resources += $consumptionASP

    # $functionApp = Get-SpqAppServiceFunctionApp -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus" -AppServicePlan $consumptionASP -StorageAccount $myStorageAccount
    # $baseTemplate.resources += $functionApp

    $cognitiveServiceAcct = Get-SpqCognitiveService -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus"
    $baseTemplate.resources += $cognitiveServiceAcct
    
    $frontDoor = Get-SpqFrontDoor `
        -ApplicationCode $applicationCode `
        -EnvironmentName $environmentName `
        -Location "centralus"

    $frontendEndpoint = Get-SpqFrontDoorFrontEndpoint -FrontDoor $frontDoor
    $loadbalancingSetting = Get-SpqFrontDoorLoadBalancingSetting -FrontDoor $frontDoor
    $healthProbeSetting = Get-SpqFrontDoorHealthProbeSetting -FrontDoor $frontDoor
    $frontDoor.properties.frontendEndpoints += $frontendEndpoint
    $frontDoor.properties.loadBalancingSettings += $loadbalancingSetting
    $frontDoor.properties.healthProbeSettings += $healthProbeSetting
    $backEnd = Get-SpqFrontDoorBackend -BackendAddress "www.hello.com"
    $backendPool = Get-SpqFrontDoorBackendPool -FrontDoor $frontDoor -LoadBalancingSetting $loadbalancingSetting -HealthProbeSetting $healthProbeSetting
    $backendPool.properties.backends += $backend
    $frontDoor.properties.backendPools += $backendPool
    $routingRule = Get-SpqFrontDoorRoutingRule -FrontDoor $frontDoor -BackendPool $backendPool -FrontendEndpoint $frontendEndpoint
    $frontDoor.properties.routingRules += $routingRule
    
    $baseTemplate.resources += $frontDoor

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