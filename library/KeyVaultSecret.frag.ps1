. ./_Abbreviations.ps1

function Get-KeyVaultSecretName {
    Param(
        [parameter(Mandatory = $true)] [object] $FragmentObject
    )

    $name = "UNEXPECTED"
    # this is checking to see if the secret-owning-object is actually a sub-object, such as an EventHubAuthoirzationRule.
    # if it is, it uses just the second part of the name, i.e. the name of the AuthoirizationRule, not the EventHub that owns it
    if ($FragmentObject.name.Split("/").Count -eq 2) {
        $name = $FragmentObject.name.Split("/")[1] + "-key"
    }
    else {
        $name = $FragmentObject.name + "-key"
    }

    return $name
}

function Get-KeyVaultSecretTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $true)] [object] $KeyOwningObject,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $KeyVaultFragmentObject
    )

    $referenceToKey = "NOTFOUND"

    switch ($KeyOwningObject.type) {
        "Microsoft.DocumentDB/databaseAccounts" { 
            $referenceToKey = Get-ReferenceToCosmosKey -CosmosFragmentObject $KeyOwningObject; break
        }
        "Microsoft.Storage/storageAccounts" {
            $referenceToKey = Get-ReferenceToStorageKey -StorageFragmentObject $KeyOwningObject; break 
        }
        "Microsoft.Search/searchServices" { 
            $referenceToKey = Get-ReferenceToSearchAdminKey -SearchFragmentObject $KeyOwningObject; break 
        }
        "Microsoft.EventHub/namespaces/AuthorizationRules" { 
            $referenceToKey = Get-ReferenceToNamespaceAuthorizationRuleKey -NamespaceAuthorizationRuleFragmentObject $KeyOwningObject; break
        }
        # Not implemented yet
        # "Microsoft.EventHub/namespaces/eventhubs" { 
        #     $referenceToKey = Get-ReferenceToEventHubKey -StorageFragmentObject $KeyOwningObject; break
        # }
    }

    
    $secretName = Get-KeyVaultSecretName -FragmentObject $KeyOwningObject

    $json = '
    {
        "type": "Microsoft.KeyVault/vaults/secrets",
        "name": "' + $KeyVaultFragmentObject.name + '/' + $secretName + '",
        "apiVersion": "2018-02-14",
        "location": "' + $Location + '",
        "dependsOn": [
            "[resourceId(''Microsoft.KeyVault/vaults'', ''' + $KeyVaultFragmentObject.name + ''')]"
        ],
        "properties": {
            "value": "' + $referenceToKey + '"
        }
    }
    '
    return ConvertFrom-Json $json
}







