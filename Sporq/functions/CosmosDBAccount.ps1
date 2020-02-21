function Get-SpqReferenceToCosmosDbAccountKey {
    Param(
        [parameter(Mandatory = $true)] [object] $CosmosDbAccount
    )

    $reference = "[listKeys(resourceId('Microsoft.DocumentDB/databaseAccounts', '" + $CosmosDbAccount.name + "'), providers('Microsoft.DocumentDB', 'databaseAccounts').apiVersions[0]).primaryMasterKey]"
    return $reference
}

function Get-SpqReferenceToCosmosDbAccountConnectionString {
    Param(
        [parameter(Mandatory = $true)] [object] $CosmosDbAccount
    )
    $reference = "[concat('AccountEndpoint=https://" + $CosmosDbAccount.name + ".documents.azure.com:443/;AccountKey=', listKeys(resourceId('Microsoft.DocumentDB/databaseAccounts', '" + $CosmosDbAccount.name + "'), providers('Microsoft.DocumentDB', 'databaseAccounts').apiVersions[0]).primaryMasterKey, ';')]"
    return $reference
}

function Get-SpqCosmosDbAccount {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $false)] [string] $LogAnalyticsResourceGroupName = "",
        [parameter(Mandatory = $false)] [string] $LogAnalyticsWorkspaceName = ""
    )
    
    $cosmosName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.DocumentDB/databaseAccounts" `
        -Location $Location

    $cosmosDiagnosticsSettingName = $cosmosName + "-diagsett"

    $diagnosticSettingJson = '
    {
        "type": "providers/diagnosticSettings",
        "name": "Microsoft.Insights/' + $cosmosDiagnosticsSettingName + '",
        "dependsOn": [
            "[resourceId(''Microsoft.DocumentDB/databaseAccounts'', ''' + $cosmosName + ''')]"
        ],
        "apiVersion": "2017-05-01-preview",
        "properties": {
            "name": "' + $cosmosDiagnosticsSettingName + '",
            "workspaceId": "[resourceId(''' + $LogAnalyticsResourceGroupName + ''', ''microsoft.operationalinsights/workspaces'', ''' + $LogAnalyticsWorkspaceName + ''')]",
            "metrics": [
                {
                    "category": "Requests",
                    "enabled": true
                }
            ],      
            "logs": [ 
                {
                  "category": "ControlPlaneRequests",
                  "enabled": true
                },
                {
                    "category": "DataPlaneRequests",
                    "enabled": true
                }
            ]
        }
    }
    '

    $diagnosticSettingObj = ConvertFrom-Json $diagnosticSettingJson

    $json = '
    {
        "type": "Microsoft.DocumentDB/databaseAccounts",
        "apiVersion": "2019-08-01",
        "name": "' + $cosmosName + '",
        "location": "' + $Location + '",
        "tags": {
            "defaultExperience": "Core (SQL)"
        },
        "kind": "GlobalDocumentDB",
        "properties": {
            "enableAutomaticFailover": false,
            "enableMultipleWriteLocations": true,
            "isVirtualNetworkFilterEnabled": false,
            "virtualNetworkRules": [],
            "databaseAccountOfferType": "Standard",
            "consistencyPolicy": {
                "defaultConsistencyLevel": "Session",
                "maxIntervalInSeconds": 5,
                "maxStalenessPrefix": 100
            },
            "locations": [
                {
                    "locationName": "' + $Location + '",
                    "failoverPriority": 0,
                    "isZoneRedundant": false
                }
            ],
            "capabilities": []
        },
        "resources": [            
        ]
    }
    '

    $obj = ConvertFrom-Json $json

    if ($LogAnalyticsResourceGroupName -ne "")
    {
        $obj.resources += $diagnosticSettingObj
    }

    return $obj
}

