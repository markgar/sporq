function Get-SpqEventHub {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $EventHubNamespace
    )

    $eventHubName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.EventHub/namespaces/eventhubs" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.EventHub/namespaces/eventhubs",
        "apiVersion": "2017-04-01",
        "name": "' + $EventHubNamespace.name + '/' + $eventHubName + '",
        "location": "Central US",
        "dependsOn": [
        "[resourceId(''Microsoft.EventHub/namespaces'', ''' + $EventHubNamespace.name + ''')]"
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


