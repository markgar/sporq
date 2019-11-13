. ./_Abbreviations.ps1

function Get-AppServicePlanTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $AppServicePlanSKU
    )
    
    $aspName = Get-ResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Web/serverfarms" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Web/serverfarms",
        "apiVersion": "2016-09-01",
        "name": "' + $aspName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "' + $AppServicePlanSKU + '"
        },
        "kind": "app",
        "properties": {}
    }
    '
    return ConvertFrom-Json $json
}