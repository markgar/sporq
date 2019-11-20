function Get-SpqReferenceToStorageKey {
    Param(
        [parameter(Mandatory = $true)] [object] $StorageAccount
    )

    $reference = "[listKeys(resourceId('Microsoft.Storage/storageAccounts', '" + $StorageAccount.name + "'), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value]"
    return $reference
}

function Get-SpqStorageAccount {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $StorageAccessTier,
        [parameter(Mandatory = $true)] [string] $StorageTier
    )

    $storageName = Get-SpqResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Storage/storageAccounts" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Storage/storageAccounts",
        "apiVersion": "2019-04-01",
        "name": "' + $storageName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "' + $StorageAccessTier + '",
            "tier": "' + $StorageTier + '"
        },
        "kind": "StorageV2",
        "properties": {
            "networkAcls": {
                "bypass": "AzureServices",
                "virtualNetworkRules": [],
                "ipRules": [],
                "defaultAction": "Allow"
            },
            "supportsHttpsTrafficOnly": true,
            "encryption": {
                "services": {
                    "file": {
                        "enabled": true
                    },
                    "blob": {
                        "enabled": true
                    }
                },
                "keySource": "Microsoft.Storage"
            },
            "accessTier": "Hot"
        },
        "metadata": {
            "exceptionGuid1": "' + $ExceptionGuid + '"
        }
    }
    '
    return ConvertFrom-Json $json
}

function Get-SpqStorageBlobServiceConfig {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $true)] [object] $StorageAccount,
        [string] $ExceptionGuid
    )

    $json = '
    {
        "type": "Microsoft.Storage/storageAccounts/blobServices",
        "apiVersion": "2019-04-01",
        "name": "' + $StorageAccount.name + '/default",
        "dependsOn": [
            "[resourceId(''Microsoft.Storage/storageAccounts'', ''' + $StorageAccount.name + ''')]"
        ],
        "properties": {
            "cors": {
                "corsRules": []
            },
            "deleteRetentionPolicy": {
                "enabled": false
            }
        }
    }
    '
    return ConvertFrom-Json $json
}