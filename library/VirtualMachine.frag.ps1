. ./_Abbreviations.ps1

function Get-VirtualMachineTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $VMSize,
        [parameter(Mandatory = $true)] [string] $AdminUserName,
        [parameter(Mandatory = $true)] [string] $AdminPwd,
        [parameter(Mandatory = $true)] [object] $NetworkInterfaceFragmentObject
    )
    
    $vmName = Get-ResourceName `
        -CommonProperties $CommonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Compute/virtualMachines" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.Compute/virtualMachines",
        "apiVersion": "2019-03-01",
        "name": "' + $vmName + '",
        "location": "' + $Location + '",
        "dependsOn": [
            "[resourceId(''Microsoft.Network/networkInterfaces/'', ''' + $NetworkInterfaceFragmentObject.name + ''')]"
        ],
        "properties": {
            "hardwareProfile": {
                "vmSize": "' + $VMSize + '"
            },
            "storageProfile": {
                "imageReference": {
                    "publisher": "MicrosoftWindowsServer",
                    "offer": "WindowsServer",
                    "sku": "2016-Datacenter",
                    "version": "latest"
                },
                "osDisk": {
                    "createOption": "FromImage"
                },
                "dataDisks": []
            },
            "osProfile": {
                "computerName": "' + $vmName + '",
                "adminUsername": "' + $AdminUserName + '",
                "adminPassword": "' + $AdminPwd + '"
            },
            "networkProfile": {
                "networkInterfaces": [
                    {
                        "id": "[resourceId(''Microsoft.Network/networkInterfaces/'', ''' + $NetworkInterfaceFragmentObject.name + ''')]"
                    }
                ]
            }
        }
    }
    '
    return ConvertFrom-Json $json
}

