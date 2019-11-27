function Get-SpqLogAnalytics {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $false)] [string] $ExceptionGuid
    )

    $logAnalyticsName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "microsoft.operationalinsights/workspaces" `
        -Location $Location

    $json = '
    {
        "type": "microsoft.operationalinsights/workspaces",
        "apiVersion": "2015-11-01-preview",
        "name": "' + $logAnalyticsName + '",
        "location": "' + $Location + '",
        "properties": {
            "sku": {
                "name": "pergb2018"
            },
            "retentionInDays": 30
        }
    }
    '
    return ConvertFrom-Json $json
}







