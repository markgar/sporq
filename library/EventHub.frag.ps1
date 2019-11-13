. ./_Abbreviations.ps1

function Get-EventHubTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $EventHubNamespaceFragmentObject
    )

    $eventHubName = Get-ResourceName `
    -CommonProperties $CommonProperties `
    -UniqueNamePhrase $UniqueNamePhrase `
    -ServiceTypeName "Microsoft.EventHub/namespaces/eventhubs" `
    -Location $Location

    $json = '
    {
        "type": "Microsoft.EventHub/namespaces/eventhubs",
        "apiVersion": "2017-04-01",
        "name": "' + $EventHubNamespaceFragmentObject.name + '/' + $eventHubName + '",
        "location": "Central US",
        "dependsOn": [
        "[resourceId(''Microsoft.EventHub/namespaces'', ''' + $EventHubNamespaceFragmentObject.name + ''')]"
        ],
        "properties": {
            "messageRetentionInDays": 1,
            "partitionCount": 2,
            "status": "Active"
        }
    }
    '
    return ConvertFrom-Json $json
}


