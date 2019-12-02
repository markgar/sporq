Write-Host "Generating Template..."

$environmentName = "dev"
$applicationCode = "q4k"

# Grab an empty base template
$baseTemplate = Get-SpqBaseTemplate


$appServicesPlan = Get-SpqAppServicePlan `
    -ApplicationCode $applicationCode `
    -EnvironmentName $environmentName `
    -Location "centralus" `
    -AppServicePlanSKU "S1"
$baseTemplate.resources += $appServicesPlan


$webSite = Get-SpqAppServiceWebSite `
    -ApplicationCode $applicationCode `
    -EnvironmentName $environmentName `
    -Location "centralus" `
    -UniqueNamePhrase "web" `
    -AppServicePlan $appServicesPlan
$baseTemplate.resources += $webSite
$webSiteAddress = $website.name + ".azurewebsites.net"

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
$backEnd = Get-SpqFrontDoorBackend -BackendAddress $webSiteAddress
$backendPool = Get-SpqFrontDoorBackendPool -FrontDoor $frontDoor -LoadBalancingSetting $loadbalancingSetting -HealthProbeSetting $healthProbeSetting
$backendPool.properties.backends += $backend
$frontDoor.properties.backendPools += $backendPool
$routingRule = Get-SpqFrontDoorRoutingRule -FrontDoor $frontDoor -BackendPool $backendPool -FrontendEndpoint $frontendEndpoint
$frontDoor.properties.routingRules += $routingRule

$baseTemplate.resources += $frontDoor

# convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10