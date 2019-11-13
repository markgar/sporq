. ./_Abbreviations.ps1

function Get-ReferenceToSearchAdminKey {
    Param(
        [parameter(Mandatory = $true)] [object] $SearchFragmentObject
    )

    $reference = "[listAdminKeys(resourceId('Microsoft.Search/searchServices', '" + $SearchFragmentObject.name + "'), providers('Microsoft.Search', 'searchServices').apiVersions[0]).primaryKey]"
    return $reference
}

function Get-SearchTemplateFragment {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $Sku,
        [parameter(Mandatory = $true)] [string] $ReplicaCount,
        [parameter(Mandatory = $true)] [string] $PartitionCount
    )
    
    $searchName = Get-ResourceName `
        -CommonProperties $CommonProperties `
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




