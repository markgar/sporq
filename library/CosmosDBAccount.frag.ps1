. ./_Abbreviations.ps1

function Get-ReferenceToCosmosKey {
    Param(
        [parameter(Mandatory = $true)] [object] $CosmosFragmentObject
    )

    $reference = "[listKeys(resourceId('Microsoft.DocumentDB/databaseAccounts', '" + $CosmosFragmentObject.name + "'), providers('Microsoft.DocumentDB', 'databaseAccounts').apiVersions[0]).primaryMasterKey]"
    return $reference
}

function Get-CosmosTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )

    $cosmosName = Get-ResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.DocumentDB/databaseAccounts" `
        -Location $Location

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
        }
    }
    '
    return ConvertFrom-Json $json
}