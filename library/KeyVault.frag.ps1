. ./_Abbreviations.ps1

function Get-KeyVaultTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $false)] [string] $ExceptionGuid
    )

    $keyVaultName = Get-ResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.KeyVault/vaults" `
        -Location $Location


    $json = '
    {
        "type": "Microsoft.KeyVault/vaults",
        "name": "' + $keyVaultName + '",
        "apiVersion": "2015-06-01",
        "location": "' + $Location + '",
        "properties": {
            "sku": {
                "family": "A",
                "name": "Standard"
            },
            "tenantId": "[subscription().tenantId]",
            "enabledForTemplateDeployment": "true",
            "accessPolicies": []
        }
    }
    '
    return ConvertFrom-Json $json
}







