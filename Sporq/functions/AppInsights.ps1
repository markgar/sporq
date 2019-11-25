function Get-SpqAppInsights {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $appInsightsName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "microsoft.insights/components" `
        -Location $Location

    $json = '
    {
        "type": "microsoft.insights/components",
        "apiVersion": "2015-05-01",
        "name": "' + $appInsightsName + '",
        "location": "' + $Location + '",
        "kind": "web",
        "properties": {
            "Application_Type": "web",
            "Flow_Type": "Redfield",
            "Request_Source": "IbizaAIExtension"
        }
    }
    '
    return ConvertFrom-Json $json
}

