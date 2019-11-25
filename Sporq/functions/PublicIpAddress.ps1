function Get-SpqPublicIpAddress {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $pipName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Network/publicIPAddresses" `
        -Location $Location
        

    $json = '
    {
        "type": "Microsoft.Network/publicIPAddresses",
        "apiVersion": "2019-09-01",
        "name": "' + $pipName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "Basic"
        },
        "properties": {
            "publicIPAllocationMethod": "Dynamic"
        }
    }
    '
    return ConvertFrom-Json $json
}

