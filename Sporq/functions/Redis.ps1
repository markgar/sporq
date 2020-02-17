function Get-SpqRedis {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $SkuName,
        [parameter(Mandatory = $true)] [string] $SkuFamily,
        [parameter(Mandatory = $true)] [int] $SkuCapacity,
        [parameter(Mandatory = $false)] [string] $LogAnalyticsResourceGroupName = "",
        [parameter(Mandatory = $false)] [string] $LogAnalyticsWorkspaceName = ""
    )
    
    $redisName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Cache/Redis" `
        -Location $Location

    $redisDiagnosticsSettingName = $redisName + "-diagsett"

    $diagnosticSettingJson = '
    {
        "type": "providers/diagnosticSettings",
        "name": "Microsoft.Insights/' + $redisDiagnosticsSettingName + '",
        "dependsOn": [
            "[resourceId(''Microsoft.Cache/Redis'', ''' + $redisName + ''')]"
        ],
        "apiVersion": "2017-05-01-preview",
        "properties": {
            "name": "' + $redisDiagnosticsSettingName + '",
            "workspaceId": "[resourceId(''' + $LogAnalyticsResourceGroupName + ''', ''microsoft.operationalinsights/workspaces'', ''' + $LogAnalyticsWorkspaceName + ''')]",
            "metrics": [
                {
                    "category": "AllMetrics",
                    "enabled": true
                }
            ]
        }
    }
    '

    $diagnosticSettingObj = ConvertFrom-Json $diagnosticSettingJson

    $json = '
    {
        "name": "' + $redisName + '",
        "type": "Microsoft.Cache/Redis",
        "apiVersion": "2018-03-01",
        "properties": {
            "sku": {
                "name": "' + $SkuName + '",
                "family": "' + $SkuFamily + '",
                "capacity": "' + $SkuCapacity + '"
            }
        },
        "location": "' + $Location + '",
        "tags": {},
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




