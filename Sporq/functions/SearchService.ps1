function Get-SpqReferenceToSearchAdminKey {
    Param(
        [parameter(Mandatory = $true)] [object] $SearchService
    )

    $reference = "[listAdminKeys(resourceId('Microsoft.Search/searchServices', '" + $SearchService.name + "'), providers('Microsoft.Search', 'searchServices').apiVersions[0]).primaryKey]"
    return $reference
}

function Get-SpqSearch {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $Sku,
        [parameter(Mandatory = $true)] [string] $ReplicaCount,
        [parameter(Mandatory = $true)] [string] $PartitionCount,
        [parameter(Mandatory = $true)] [string] $LogAnalyticsResourceGroupName,
        [parameter(Mandatory = $true)] [string] $LogAnalyticsWorkspaceName
    )
    
    $searchName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Search/searchServices" `
        -Location $Location

    $searchDiagnosticsSettingName = $searchName + "-diagsett"

    $json = '
    {
        "type": "Microsoft.Search/searchServices",
        "apiVersion": "2015-08-19",
        "name": "' + $searchName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "' + $Sku + '"
        },
        "properties": {
            "replicaCount": ' + $ReplicaCount + ',
            "partitionCount": ' + $PartitionCount + ',
            "hostingMode": "Default"
        },
        "resources": [            
            {
                "type": "providers/diagnosticSettings",
                "name": "Microsoft.Insights/' + $searchDiagnosticsSettingName + '",
                "dependsOn": [
                    "[resourceId(''Microsoft.Search/searchServices'', ''' + $searchName + ''')]"
                ],
                "apiVersion": "2017-05-01-preview",
                "properties": {
                    "name": "' + $searchDiagnosticsSettingName + '",
                    "workspaceId": "[resourceId(''' + $LogAnalyticsResourceGroupName + ''', ''microsoft.operationalinsights/workspaces'', ''' + $LogAnalyticsWorkspaceName + ''')]",
                    "metrics": [
                        {
                            "category": "AllMetrics",
                            "enabled": true
                        }
                    ],      
                    "logs": [ 
                        {
                          "category": "OperationLogs",
                          "enabled": true
                        }
                    ]
                }
            }
        ]
    }
    '
    return ConvertFrom-Json $json
}




