. ./_Abbreviations.ps1

function Get-ReferenceToNamespaceAuthorizationRuleKey {
    Param(
        [parameter(Mandatory = $true)] [object] $NamespaceAuthorizationRuleFragmentObject
    )

    $reference = "[listKeys(resourceId('Microsoft.EventHub/namespaces/AuthorizationRules', '" + $NamespaceAuthorizationRuleFragmentObject.name.Split('/')[0] + "','" + $NamespaceAuthorizationRuleFragmentObject.name.Split('/')[1] + "'), providers('Microsoft.EventHub', 'namespaces/AuthorizationRules').apiVersions[0]).primaryKey]"
    return $reference
}

function Get-EventHubNamespaceTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $eventHubNamespaceName = Get-ResourceName `
        -CommonProperties $CommonProperties `
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


function Get-EventHubNamespaceAuthorizationRuleTemplateFragement {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $EventHubNamespaceObject
    )

    $eventHubNamespaceAuthorizationRuleName = Get-ResourceName `
    -CommonProperties $CommonProperties `
    -UniqueNamePhrase $UniqueNamePhrase `
    -ServiceTypeName "Microsoft.EventHub/namespaces/AuthorizationRules" `
    -Location $Location

    $json = '
    {
        "type": "Microsoft.EventHub/namespaces/AuthorizationRules",
        "apiVersion": "2017-04-01",
        "name": "' + $EventHubNamespaceObject.name + '/' + $eventHubNamespaceAuthorizationRuleName + '",
        "location": "' + $Location + '",
        "dependsOn": [
            "[resourceId(''Microsoft.EventHub/namespaces'', ''' + $EventHubNamespaceObject.name + ''')]"
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