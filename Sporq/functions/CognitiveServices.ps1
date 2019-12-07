function Get-SpqCognitiveService {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $cognitiveServiceAccountName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.CognitiveServices/accounts" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.CognitiveServices/accounts",
        "apiVersion": "2016-02-01-preview",
        "name": "' + $cognitiveServiceAccountName + '",
        "location": "' + $Location + '",
        "sku": {
          "name": "S0"
        },
        "kind": "CognitiveServices",
        "properties": {}
      }
    '
    return ConvertFrom-Json $json
}



