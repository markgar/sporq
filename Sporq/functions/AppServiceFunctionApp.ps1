function Get-SpqAppServiceFunctionApp {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $AppServicePlan,
        [parameter(Mandatory = $true)] [object] $StorageAccount
    )

    $webSiteName = Get-SpqResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Web/sites/functions" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Web/sites",
        "apiVersion": "2016-08-01",
        "name": "' + $webSiteName + '",
        "location": "' + $Location + '",
        "kind": "functionapp",
        "properties": {
            "serverFarmId": "[resourceId(''Microsoft.Web/serverfarms'', ''' + $AppServicePlan.name + ''')]"
        },
        "dependsOn": [
            "[resourceId(''Microsoft.Web/serverfarms'', ''' + $AppServicePlan.name + ''')]",
            "[resourceId(''Microsoft.Storage/storageAccounts'', ''' + $StorageAccount.name + ''')]"
        ]
    }
    '
    return ConvertFrom-Json $json
}