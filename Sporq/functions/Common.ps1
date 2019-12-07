function Get-SpqResourceName {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $false)] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [string] $ServiceTypeName,
        [parameter(Mandatory = $false)] [string] $Location = $null
    )

    if ($ServiceTypeName -eq "Microsoft.Storage/storageAccounts") {
        $separationCharacter = ""
    }
    else {
        $separationCharacter = "-"
    }

    $resourceTypeAbbreviation = Get-SpqResourceTypeAbbreviation -ServiceTypeName $ServiceTypeName
    

    #################################
    # customize this to your liking #
    #################################

    # Suggestions:
    # applicationcode-environment-resourcetype-additionalname-location
    # this sorts the similar resource types together first, then location
    #
    # q4k-dev-usc-site-web
    # q4k-dev-usc-site-api
    # q4k-dev-use2-site-web
    # q4k-dev-use2-site-api
    # 
    #
    # applicationcode-environment-location-resourcetype-additionalname
    # this sorts everything in the same location first, then resource type
    # example: web and api app, each deployed in usc and use2
    #
    # q4k-dev-site-api-usc
    # q4k-dev-site-web-usc
    # q4k-dev-site-api-use2
    # q4k-dev-site-web-use2

    # Application Code
    $resourceName = `
        $ApplicationCode

    # Environment Name
    $resourceName = $resourceName + `
        $separationCharacter + `
        $EnvironmentName 

    # Resource Type Abbreviation
    $resourceName = $resourceName + `
        $separationCharacter + `
        $resourceTypeAbbreviation

    # Additional Name Phrase
    if ($UniqueNamePhrase) {
        # add the optional disambiguation phrase if it isn't null
        # this is a cryptic looking if statemet, but it tests for null
        $resourceName = $resourceName + `
            $separationCharacter + `
            $UniqueNamePhrase
    }
    
    # Location
    if (($ServiceTypeName -ne "ResourceGroup") -and ($ServiceTypeName -ne "Microsoft.Network/frontDoors")) {
        $locationAbbreviation = Get-SpqLocationAbbreviation -Location $Location
        $resourceName = $resourceName + `
            $separationCharacter + `
            $locationAbbreviation        
    }

    return $resourceName
}

#region Resource Abbrebiation
function Get-SpqResourceTypeAbbreviation {
    Param(
        [parameter(Mandatory = $true)] [string] $ServiceTypeName
    )

    $abbreviation = "ResourceTypeNotFound"

    switch ($ServiceTypeName) {
        "ResourceGroup" { $abbreviation = "rg"; break }
        "microsoft.insights/components" { $abbreviation = "appin"; break }
        "Microsoft.Web/serverfarms" { $abbreviation = "appsvcpl"; break }
        "Microsoft.Web/serverfarms/consumption" { $abbreviation = "appsvcplc"; break }
        "Microsoft.Web/sites" { $abbreviation = "appsvcsite"; break }
        "Microsoft.Web/sites/functions" { $abbreviation = "appsvcfunc"; break }
        "Microsoft.DocumentDB/databaseAccounts" { $abbreviation = "csmsacc"; break }
        "Microsoft.Storage/storageAccounts" { $abbreviation = "strg"; break }
        "Microsoft.Search/searchServices" { $abbreviation = "srch"; break }
        "Microsoft.EventHub/namespaces" { $abbreviation = "evhns"; break }
        "Microsoft.KeyVault/vaults" { $abbreviation = "keyvlt"; break }
        "Microsoft.EventHub/namespaces/eventhubs" { $abbreviation = "evhb"; break }
        "Microsoft.EventHub/namespaces/AuthorizationRules" { $abbreviation = "evhbnsar"; break }
        "Microsoft.Compute/virtualMachines" { $abbreviation = "vm"; break }
        "Microsoft.Network/networkInterfaces" { $abbreviation = "nic"; break }
        "Microsoft.Network/publicIPAddresses" { $abbreviation = "pip"; break }
        "Microsoft.AppConfiguration/configurationStores" { $abbreviation = "appcfg"; break }
        "Microsoft.Cache/Redis" { $abbreviation = "redis"; break }
        "microsoft.operationalinsights/workspaces" { $abbreviation = "loganltcs"; break }
        "Microsoft.Network/frontDoors" { $abbreviation = "frtdr"; break }
        "Microsoft.CognitiveServices/accounts" { $abbreviation = "cogsvc"; break }
        
    }

    return $abbreviation
}
#endregion

function Get-SpqLocationAbbreviation {
    Param(
        [parameter(Mandatory = $true)] [string] $Location
    )

    $abbreviation = "LocationNotFound"
    
    switch ($Location) {
        "eastasia" { $abbreviation = "ase"; break }
        "southeastasia" { $abbreviation = "asse"; break }
        "australiacentral" { $abbreviation = "auc"; break }
        "australiacentral2" { $abbreviation = "auc2"; break }
        "australiaeast" { $abbreviation = "aue"; break }
        "australiasoutheast" { $abbreviation = "ause"; break }
        "brazilsouth" { $abbreviation = "bzs"; break }
        "canadacentral" { $abbreviation = "cac"; break }
        "canadaeast" { $abbreviation = "cae"; break }
        "northeurope" { $abbreviation = "eun"; break }
        "westeurope" { $abbreviation = "euw"; break }
        "francecentral" { $abbreviation = "frc"; break }
        "francesouth" { $abbreviation = "frs"; break }
        "germanynorth" { $abbreviation = "gen"; break }
        "germanywestcentral" { $abbreviation = "gewc"; break }
        "centralindia" { $abbreviation = "inc"; break }
        "southindia" { $abbreviation = "ins"; break }
        "westindia" { $abbreviation = "inw"; break }
        "japaneast" { $abbreviation = "jpe"; break }
        "japanwest" { $abbreviation = "jpw"; break }
        "koreacentral" { $abbreviation = "koc"; break }
        "koreasouth" { $abbreviation = "kos"; break }
        "norwayeast" { $abbreviation = "noe"; break }
        "norwaywest" { $abbreviation = "now"; break }
        "southafricanorth" { $abbreviation = "san"; break }
        "southafricawest" { $abbreviation = "saw"; break }
        "switzerlandnorth" { $abbreviation = "swn"; break }
        "switzerlandwest" { $abbreviation = "sww"; break }
        "uaecentral" { $abbreviation = "uaec"; break }
        "uaenorth" { $abbreviation = "uaen"; break }
        "uksouth" { $abbreviation = "uks"; break }
        "ukwest" { $abbreviation = "ukw"; break }
        "centralus" { $abbreviation = "usc"; break }
        "eastus" { $abbreviation = "use"; break }
        "eastus2" { $abbreviation = "use2"; break }
        "northcentralus" { $abbreviation = "usnc"; break }
        "southcentralus" { $abbreviation = "ussc"; break }
        "westus" { $abbreviation = "usw"; break }
        "westus2" { $abbreviation = "usw2"; break }
        "westcentralus" { $abbreviation = "uswc"; break }
    }

    return $abbreviation
}