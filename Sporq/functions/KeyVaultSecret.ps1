function Get-SpqKeyVaultSecretName {
    Param(
        [parameter(Mandatory = $true)] [object] $ResourceObject
    )

    $name = "UNEXPECTED"
    # this is checking to see if the secret-owning-object is actually a sub-object, such as an EventHubAuthoirzationRule.
    # if it is, it uses just the second part of the name, i.e. the name of the AuthoirizationRule, not the EventHub that owns it
    if ($ResourceObject.name.Split("/").Count -eq 2) {
        $name = $ResourceObject.name.Split("/")[1] + "-key"
    }
    else {
        $name = $ResourceObject.name + "-key"
    }

    return $name
}

function Get-SpqKeyVaultSecret {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $true)] [object] $KeyOwningObject,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $KeyVault
    )

    $referenceToKey = "NOTFOUND"

    switch ($KeyOwningObject.type) {
        "Microsoft.DocumentDB/databaseAccounts" { 
            $referenceToKey = Get-SpqReferenceToCosmosDbAccountKey -CosmosDbAccount $KeyOwningObject; break
        }
        "Microsoft.Storage/storageAccounts" {
            $referenceToKey = Get-SpqReferenceToStorageKey -Storage $KeyOwningObject; break 
        }
        "Microsoft.Search/searchServices" { 
            $referenceToKey = Get-SpqReferenceToSearchAdminKey -Search $KeyOwningObject; break 
        }
        "Microsoft.EventHub/namespaces/AuthorizationRules" { 
            $referenceToKey = Get-SpqReferenceToNamespaceAuthorizationRuleKey -NamespaceAuthorizationRule $KeyOwningObject; break
        }
        # Not implemented yet
        # "Microsoft.EventHub/namespaces/eventhubs" { 
        #     $referenceToKey = Get-ReferenceToEventHubKey -Storage $KeyOwningObject; break
        # }
    }

    
    $secretName = Get-SpqKeyVaultSecretName -ResourceObject $KeyOwningObject

    $json = '
    {
        "type": "Microsoft.KeyVault/vaults/secrets",
        "name": "' + $KeyVault.name + '/' + $secretName + '",
        "apiVersion": "2018-02-14",
        "location": "' + $Location + '",
        "dependsOn": [
            "[resourceId(''Microsoft.KeyVault/vaults'', ''' + $KeyVault.name + ''')]"
        ],
        "properties": {
            "value": "' + $referenceToKey + '"
        }
    }
    '
    return ConvertFrom-Json $json
}







