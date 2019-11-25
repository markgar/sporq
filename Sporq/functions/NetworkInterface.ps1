function Get-SpqNetworkInterface {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $VNetResourceGroupName,
        [parameter(Mandatory = $true)] [string] $VNetName,
        [parameter(Mandatory = $true)] [string] $SubnetName,
        [parameter(Mandatory = $false)] [object] $PublicIP = $null
    )
    
    $nicName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Network/networkInterfaces" `
        -Location $Location
        
    # if passed a PublicIpObject, then add the clause for the reference
    if ($PublicIP) {
        $publicIpFragment = '
        "publicIPAddress": {
            "id": "[resourceId(''Microsoft.Network/networkInterfaces/'', ''' + $PublicIP.name + ''')]"
        },
        '
    }
    else {
        $publicIpFragment = ''
    }

    $json = '
    {
        "type": "Microsoft.Network/networkInterfaces",
        "apiVersion": "2019-09-01",
        "name": "' + $nicName + '",
        "location": "' + $Location + '",
        "properties": {
            "ipConfigurations": [
                {
                    "name": "ipconfig1",
                    "properties": {
                        "privateIPAllocationMethod": "Dynamic",' `
        + $publicIpFragment + `
        '"subnet": {
                            "id": "[resourceId(''' + $VNetResourceGroupName + ''', ''Microsoft.Network/virtualNetworks/subnets'', ''' + $VNetName + ''', ''' + $SubnetName + ''')]"
                        }
                    }
                }
            ],
            "enableAcceleratedNetworking": false,
            "enableIPForwarding": false
        }
    }
    '
    return ConvertFrom-Json $json
}

