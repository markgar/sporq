function Get-SpqFrontDoor {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $frontDoorName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Network/frontDoors"

    $json = '
    {
        "apiVersion": "2019-04-01",
        "type": "Microsoft.Network/frontDoors",
        "name": "' + $frontDoorName + '",
        "tags": {},
        "location": "' + $Location + '",
        "properties": {
            "frontendEndpoints": [],
            "loadBalancingSettings": [],
            "healthProbeSettings": [],
            "backendPools": [],
            "routingRules": []
        }
    }
    '
    return ConvertFrom-Json $json
}

function Get-SpqFrontDoorFrontEndpoint {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $FrontDoor
    )
    
    $frontDoorEndPointName = $FrontDoor.name + "-frontend" + $UniqueNamePhrase

    $json = '
    {
        "name": "' + $frontDoorEndPointName + '",
        "properties": {
            "hostName": "' + $FrontDoor.name + '.azurefd.net",
            "sessionAffinityEnabledState": "Disabled"
        }
    }
    '

    return ConvertFrom-Json $json
}

function Get-SpqFrontDoorLoadBalancingSetting {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $FrontDoor
    )
    
    $frontDoorLoadBalancingSettingName = $FrontDoor.name + "-loadbalsett" + $UniqueNamePhrase

    $json = '
    {
        "name": "' + $frontDoorLoadBalancingSettingName + '",
        "properties": {
            "sampleSize": 4,
            "successfulSamplesRequired": 2
        }
    }
    '

    return ConvertFrom-Json $json
}


function Get-SpqFrontDoorHealthProbeSetting {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $FrontDoor
    )
    
    $frontDoorHealthProbeSettingName = $FrontDoor.name + "-healthprobesett" + $UniqueNamePhrase

    $json = '
    {
        "name": "' + $frontDoorHealthProbeSettingName + '",
        "properties": {
            "path": "/",
            "protocol": "Http",
            "intervalInSeconds": 120
        }
    }
    '

    return ConvertFrom-Json $json
}

function Get-SpqFrontDoorBackend {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [string] $BackendAddress
    )

    $json = '
    {
        "address": "' + $BackendAddress + '",
        "backendHostHeader": "' + $BackendAddress + '",
        "httpPort": 80,
        "httpsPort": 443,
        "weight": 50,
        "priority": 1,
        "enabledState": "Enabled"
    }
    '

    return ConvertFrom-Json $json
}

function Get-SpqFrontDoorBackendPool {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $FrontDoor,
        [parameter(Mandatory = $true)] [object] $LoadBalancingSetting,
        [parameter(Mandatory = $true)] [object] $HealthProbeSetting
    )
    
    $frontDoorBackendPoolName = $FrontDoor.name + "-backendpool" + $UniqueNamePhrase

    $json = '
    {
        "name": "' + $frontDoorBackendPoolName + '",
        "properties": {
            "backends": [

            ],
            "loadBalancingSettings": {
                "id": "[resourceId(''Microsoft.Network/frontDoors/loadBalancingSettings'', ''' + $FrontDoor.name + ''', ''' + $LoadBalancingSetting.name + ''')]"
            },
            "healthProbeSettings": {
                "id": "[resourceId(''Microsoft.Network/frontDoors/healthProbeSettings'', ''' + $FrontDoor.name + ''', ''' + $HealthProbeSetting.name + ''')]"
            }
        }
    }
    '

    return ConvertFrom-Json $json
}

function Get-SpqFrontDoorRoutingRule {
    Param(
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $FrontDoor,
        [parameter(Mandatory = $true)] [object] $BackendPool,
        [parameter(Mandatory = $true)] [object] $FrontendEndpoint

    )
    
    $frontDoorRoutingRuleName = $FrontDoor.name + "-routingRule" + $UniqueNamePhrase

    $json = '
    {
        "name": "' + $frontDoorRoutingRuleName + '",
        "properties": {
            "frontendEndpoints": [
                {
                    "id": "[resourceId(''Microsoft.Network/frontDoors/frontendEndpoints'', ''' + $FrontDoor.name + ''', ''' + $FrontendEndpoint.name + ''')]"
                }
            ],
            "acceptedProtocols": [
                "Http",
                "Https"
            ],
            "patternsToMatch": [
                "/*"
            ],
            "routeConfiguration": {
                "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",                                
                "forwardingProtocol": "MatchRequest",
                "backendPool": {
                    "id": "[resourceId(''Microsoft.Network/frontDoors/backendPools'', ''' + $FrontDoor.name + ''', ''' + $BackendPool.name + ''')]"
                }                                
            },
            "enabledState": "Enabled"
        }
    }
    '

    return ConvertFrom-Json $json
}