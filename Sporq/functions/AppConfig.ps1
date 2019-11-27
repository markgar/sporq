function Get-SpqAppConfiguration {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid
    )
    
    $appConfigName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.AppConfiguration/configurationStores" `
        -Location $Location

    $json = '

    {
        "name": "' + $appConfigName + '",
        "type": "Microsoft.AppConfiguration/configurationStores",
        "apiVersion": "2019-02-01-preview",
        "location": "' + $Location + '",
        "tags": { },
        "properties": { }
    }
    '
    return ConvertFrom-Json $json
}



