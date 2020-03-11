function  Install-NewCosmosDbKey {
    Param(
        [parameter(Mandatory = $true)] [string] $ResourceGroupName,
        [parameter(Mandatory = $true)] [string] $KeyName,
        [parameter(Mandatory = $true)] [string] $KeyVaultName,
        [parameter(Mandatory = $true)] [string] $CosmosDbAccountName,
        [parameter(Mandatory = $true)] [object] $KeyReferenceConfig
    )

    $keyKind = @{ "keyKind" = "$KeyName" }

    $keys = Invoke-AzResourceAction -Action regenerateKey `
        -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ApiVersion "2015-04-08" `
        -ResourceGroupName $ResourceGroupName -Name $CosmosDbAccountName -Parameters $keyKind -Force

    if ($keyName -eq "Primary") {
        $keyValue = $keys.primaryMasterKey
    }
    else {
        $keyValue = $keys.secondaryMasterKey
    }

    $cosmosConnectionString = "AccountEndpoint=https://" + $CosmosDbAccountName + ".documents.azure.com:443/;AccountKey=" + $keyValue + ";"
    # get secret ready to store in key vault
    $secretValue = ConvertTo-SecureString $cosmosConnectionString -AsPlainText -Force

    # store in key vault
    $secretName = $CosmosDbAccountName + "-key"
    Write-Host "Storing Secret"$SecretName
    $SetKeyResult = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $secretValue

    $WebApp = Get-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName
    $appSettingList = $WebApp.SiteConfig.AppSettings

    $hash = @{}
    ForEach ($kvp in $appSettingList) {
        $hash[$kvp.Name] = $kvp.Value
    }

    $hash[$KeyReferenceConfig.WebSiteSettingName] = "@Microsoft.KeyVault(SecretUri=" + $SetKeyResult.Id + ")"

    $SetResult = Set-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName -AppSettings $hash
}

function  Install-NewEventHubNamespaceKey {
    Param(
        [parameter(Mandatory = $true)] [string] $ResourceGroupName,
        [parameter(Mandatory = $true)] [string] $KeyName,
        [parameter(Mandatory = $true)] [string] $KeyVaultName,
        [parameter(Mandatory = $true)] [string] $EventHubNamespaceName,
        [parameter(Mandatory = $true)] [object] $KeyReferenceConfig
    )

    Write-Host "Getting Auth Rules..."
    $authRules = Get-AzEventHubAuthorizationRule -ResourceGroupName $ResourceGroupName -NamespaceName $EventHubNamespaceName
    Write-Host $authRules.Count"Auth Rule(s) Found"
    foreach ($authRule in $authRules) {
        $fullName = $EventHubNamespaceName + "/" + $authRule.name

        if ($KeyName -eq "primary") {
            $keyKind = @{ "KeyType" = "PrimaryKey" }
        }
        else {
            $keyKind = @{ "KeyType" = "SecondaryKey" }
        }
        

        Write-Host "Regenerating Key for"$fullName
        $keys = Invoke-AzResourceAction -Action regenerateKeys `
            -ResourceType "Microsoft.EventHub/namespaces/AuthorizationRules" -ApiVersion "2017-04-01" `
            -ResourceGroupName $ResourceGroupName -Name $fullName -Parameters $keyKind -Force

        Write-Host "Retrieving Keys for"$fullName
        $keys = Invoke-AzResourceAction -Action listKeys `
            -ResourceType "Microsoft.EventHub/namespaces/AuthorizationRules" -ApiVersion "2017-04-01" `
            -ResourceGroupName $ResourceGroupName -Name $fullName -Force
    
        if ($keyName -eq "Primary") {
            $keyValue = $keys.primaryKey
        }
        else {
            $keyValue = $keys.secondaryKey
        }

        # get secret ready to store in key vault
        $secretValue = ConvertTo-SecureString $keyValue -AsPlainText -Force

        # store in key vault
        $secretName = $authRule.name + "-key"
        Write-Host "Storing Secret"$SecretName
        $SetKeyResult = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $secretValue

        $WebApp = Get-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName
        $appSettingList = $WebApp.SiteConfig.AppSettings

        $hash = @{}
        ForEach ($kvp in $appSettingList) {
            $hash[$kvp.Name] = $kvp.Value
        }

        $hash[$KeyReferenceConfig.WebSiteSettingName] = "@Microsoft.KeyVault(SecretUri=" + $SetKeyResult.Id + ")"

        $SetResult = Set-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName -AppSettings $hash
    }

}

function  Install-NewSearchAdminKey {
    Param(
        [parameter(Mandatory = $true)] [string] $ResourceGroupName,
        [parameter(Mandatory = $true)] [string] $KeyName,
        [parameter(Mandatory = $true)] [string] $KeyVaultName,
        [parameter(Mandatory = $true)] [string] $SearchServiceName,
        [parameter(Mandatory = $true)] [object] $KeyReferenceConfig
    )

    $results = New-AzSearchAdminKey -ResourceGroupName $ResourceGroupName -ServiceName $SearchServiceName -KeyKind $KeyName -Force
    if ($keyName = "primary") {
        $keyValue = $results.primary
    }
    else {
        $keyValue = $results.secondary
    }
    

    # get secret ready to store in key vault
    $secretValue = ConvertTo-SecureString $keyValue -AsPlainText -Force

    # store in key vault
    $secretName = $SearchServiceName + "-key"
    Write-Host "Storing Secret"$SecretName
    $SetKeyResult = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $secretValue

    $WebApp = Get-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName
    $appSettingList = $WebApp.SiteConfig.AppSettings

    $hash = @{}
    ForEach ($kvp in $appSettingList) {
        $hash[$kvp.Name] = $kvp.Value
    }

    $hash[$KeyReferenceConfig.WebSiteSettingName] = "@Microsoft.KeyVault(SecretUri=" + $SetKeyResult.Id + ")"

    $SetResult = Set-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName -AppSettings $hash
}

function  Install-NewStorageKey {
    Param(
        [parameter(Mandatory = $true)] [string] $ResourceGroupName,
        [parameter(Mandatory = $true)] [string] $KeyName,
        [parameter(Mandatory = $true)] [string] $KeyVaultName,
        [parameter(Mandatory = $true)] [string] $StorageAccountName,
        [parameter(Mandatory = $true)] [object] $KeyReferenceConfig
    )
    if ($KeyName.tolower() -eq "primary") {
        $keyName = "key1"
        $keyOrdinal = 0;
    }

    if ($KeyName.tolower() -eq "secondary") {
        $keyName = "key2"
        $keyOrdinal = 1;
    }

    # rotate primary key
    $NewKeyResult = New-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName  -KeyName $keyName

    # retrieve primary key
    $storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName).Value[$keyOrdinal]

    $storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=" + $StorageAccountName+ ";AccountKey=" + $storageAccountKey + ";EndpointSuffix=core.windows.net"
    # get secret ready to store in key vault
    $secretValue = ConvertTo-SecureString $storageConnectionString -AsPlainText -Force

    $secretName = $StorageAccountName + "-key"
    Write-Host "Storing Secret"$SecretName
    $SetKeyResult = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $secretValue

    $WebApp = Get-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName
    $appSettingList = $WebApp.SiteConfig.AppSettings

    $hash = @{}
    ForEach ($kvp in $appSettingList) {
        $hash[$kvp.Name] = $kvp.Value
    }

    $hash[$KeyReferenceConfig.WebSiteSettingName] = "@Microsoft.KeyVault(SecretUri=" + $SetKeyResult.Id + ")"

    $SetResult = Set-AzWebApp -ResourceGroupName $KeyReferenceConfig.WebSiteResourceGroupName -Name $KeyReferenceConfig.WebSiteName -AppSettings $hash
}


function  Install-NewKeys {
    Param(
        [parameter(Mandatory = $true)] [string] $ResourceGroupName,
        [string] $KeyName
    )
    # get the resources in the resource 
    Write-Host "Getting resources in"$resourceGroupName
    $resources = Get-AzResource -ResourceGroupName $resourceGroupName

    $keyVaultName = "NOTFOUND"
    # find key vault
    Write-Host "Finding the KeyVault"
    foreach ($resource in $resources) {
        if ($resource.type -eq "Microsoft.KeyVault/vaults") {
            $keyVaultName = $resource.name
        }
    }
    if ($keyVaultName -ne "NOTFOUND") {
        Write-Host "Found KeyVault"$keyVaultname
    }

    $json = 
    '
    {
        "resource1":
        {
            "WebSiteSettingName": "AzureWebJobsStorage",
            "WebSiteResourceGroupName": "resourcegroup",
            "WebSiteName": "websitename"
        }
    }
    '

    $config = ConvertFrom-Json $json

    Write-Host "Looping through ResourceGroup again for resources with keys to rotate"
    foreach ($resource in $resources) {
        $resourceName = $resource.Name
        switch ($resource.type) {
            "Microsoft.Storage/storageAccounts" {
                Write-Host "Found Storage Account"$resourceName 
                Install-NewStorageKey -KeyName $KeyName -KeyVaultName $keyVaultName -ResourceGroupName $resourceGroupName -StorageAccountName $resource.name -KeyReferenceConfig $config.$resourceName
                break 
            }
            "Microsoft.Search/searchServices" {
                Write-Host "Found Search Service"$resourceName 
                Install-NewSearchAdminKey -KeyName $KeyName -KeyVaultName $keyVaultName -ResourceGroupName $resourceGroupName -SearchServiceName $resourceName -KeyReferenceConfig $config.$resourceName
                break 
            }
            "Microsoft.DocumentDB/databaseAccounts" {
               Write-Host "Found CosmosDB"$resourceName 
               Install-NewCosmosDbKey -KeyName $KeyName -KeyVaultName $keyVaultName -ResourceGroupName $resourceGroupName -CosmosDbAccountName $resourceName -KeyReferenceConfig $config.$resourceName
               break 
            }
            "Microsoft.EventHub/namespaces" {
                Write-Host "Found EventHub Namespace"$resourceName 
                Install-NewEventHubNamespaceKey -KeyName $KeyName -KeyVaultName $keyVaultName -ResourceGroupName $resourceGroupName -EventHubNamespaceName $resourceName -KeyReferenceConfig $config.$resourceName
                break 
            }
        }

    }
}


Install-NewKeys -ResourceGroupName "serverless-todo" -KeyName "Primary"