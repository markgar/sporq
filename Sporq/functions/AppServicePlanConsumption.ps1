function Get-SpqAppServicePlanConsumption {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $aspName = Get-SpqResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Web/serverfarms/consumption" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Web/serverfarms",
        "apiVersion": "2016-09-01",
        "name": "' + $aspName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "Y1",
            "tier": "Dynamic"
        },
        "kind": "functionapp",
        "properties": {}
    }
    '
    return ConvertFrom-Json $json
}