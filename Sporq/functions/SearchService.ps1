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
        [parameter(Mandatory = $true)] [string] $PartitionCount
    )
    
    $searchName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.Search/searchServices" `
        -Location $Location


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
        }
    }
    '
    return ConvertFrom-Json $json
}




