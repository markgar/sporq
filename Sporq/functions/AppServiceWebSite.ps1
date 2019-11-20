function Get-SpqAppServiceWebSite {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $AppServicePlan
    )

    $webSiteName = Get-SpqResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Web/sites" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Web/sites",
        "apiVersion": "2016-08-01",
        "name": "' + $webSiteName + '",
        "location": "' + $Location + '",
        "kind": "app",
        "properties": {
            "clientAffinityEnabled": true,
            "httpsOnly": true,
            "serverFarmId": "[resourceId(''Microsoft.Web/serverfarms'', ''' + $AppServicePlan.name + ''')]"
        },
        "dependsOn": [
            "[resourceId(''Microsoft.Web/serverfarms'', ''' + $AppServicePlan.name + ''')]"
        ]
    }
    '
    return ConvertFrom-Json $json
}