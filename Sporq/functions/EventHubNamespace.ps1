function Get-SpqReferenceToNamespaceAuthorizationRuleKey {
    Param(
        [parameter(Mandatory = $true)] [object] $NamespaceAuthorizationRule
    )

    $reference = "[listKeys(resourceId('Microsoft.EventHub/namespaces/AuthorizationRules', '" + $NamespaceAuthorizationRule.name.Split('/')[0] + "','" + $NamespaceAuthorizationRule.name.Split('/')[1] + "'), providers('Microsoft.EventHub', 'namespaces/AuthorizationRules').apiVersions[0]).primaryKey]"
    return $reference
}

function Get-SpqEventHubNamespace {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $eventHubNamespaceName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.EventHub/namespaces" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.EventHub/namespaces",
        "apiVersion": "2017-04-01",
        "name": "' + $eventHubNamespaceName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "Standard",
            "tier": "Standard",
            "capacity": 1
        },
        "properties": {
            "isAutoInflateEnabled": false,
            "maximumThroughputUnits": 0
        }
    }
    '
    return ConvertFrom-Json $json
}


function Get-SpqEventHubNamespaceAuthorizationRule {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $EventHubNamespace
    )

    $eventHubNamespaceAuthorizationRuleName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.EventHub/namespaces/AuthorizationRules" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.EventHub/namespaces/AuthorizationRules",
        "apiVersion": "2017-04-01",
        "name": "' + $EventHubNamespace.name + '/' + $eventHubNamespaceAuthorizationRuleName + '",
        "location": "' + $Location + '",
        "dependsOn": [
            "[resourceId(''Microsoft.EventHub/namespaces'', ''' + $EventHubNamespace.name + ''')]"
        ],
        "properties": {
            "rights": [
                "Listen",
                "Manage",
                "Send"
            ]
        }
    }
    '
        
    return ConvertFrom-Json $json 
}