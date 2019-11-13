. ./_Abbreviations.ps1

function Get-AppServiceWebSiteTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $ASPFragmentObject
    )

    $webSiteName = Get-ResourceName `
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
            "serverFarmId": "[resourceId(''Microsoft.Web/serverfarms'', ''' + $ASPFragmentObject.name + ''')]"
        },
        "dependsOn": [
            "[resourceId(''Microsoft.Web/serverfarms'', ''' + $ASPFragmentObject.name + ''')]"
        ]
    }
    '
    return ConvertFrom-Json $json
}