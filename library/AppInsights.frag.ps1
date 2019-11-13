. ./_Abbreviations.ps1

function Get-AppInsightsTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $appInsightsName = Get-ResourceName `
        -CommonProperties $CommonProperties `
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

