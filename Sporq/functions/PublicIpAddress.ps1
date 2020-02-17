function Get-SpqPublicIpAddress {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $false)] [string] $LogAnalyticsResourceGroupName = "",
        [parameter(Mandatory = $false)] [string] $LogAnalyticsWorkspaceName = ""
    )
    
    $pipName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Network/publicIPAddresses" `
        -Location $Location
    
    $pipDiagnosticsSettingName = $pipName + "-diagsett"  

    $diagnosticSettingJson = '
    {
        "type": "providers/diagnosticSettings",
        "name": "Microsoft.Insights/' + $pipDiagnosticsSettingName + '",
        "dependsOn": [
            "[resourceId(''Microsoft.Network/publicIPAddresses'', ''' + $pipName + ''')]"
        ],
        "apiVersion": "2017-05-01-preview",
        "properties": {
            "name": "' + $pipDiagnosticsSettingName + '",
            "workspaceId": "[resourceId(''' + $LogAnalyticsResourceGroupName + ''', ''microsoft.operationalinsights/workspaces'', ''' + $LogAnalyticsWorkspaceName + ''')]",
            "metrics": [
                {
                    "category": "AllMetrics",
                    "enabled": true
                }
            ],      
            "logs": [ 
                {
                    "category": "DDoSProtectionNotifications",
                    "enabled": true
                },
                {
                    "category": "DDoSMitigationFlowLogs",
                    "enabled": true
                },
                {
                    "category": "DDoSMitigationReports",
                    "enabled": true
                }
            ]
        }
    }
    '

    $diagnosticSettingObj = ConvertFrom-Json $diagnosticSettingJson

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
        },
        "resources": [            
        ]
    }
    '

    $obj = ConvertFrom-Json $json

    if ($LogAnalyticsResourceGroupName -ne "")
    {
        $obj.resources += $diagnosticSettingObj
    }

    return $obj
}

