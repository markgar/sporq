function Get-SpqAppServiceAppSettings {
    Param(
        [parameter(Mandatory = $true)] [object] $AppServiceSite,
        [parameter(Mandatory = $true)] [object] $AppSettingsKeyValueHashtable
    )

    $properties = ConvertTo-Json $AppSettingsKeyValueHashtable

    $json = '
    {
        "apiVersion": "2015-08-01",
        "name": "appsettings",
        "type": "config",
        "dependsOn": [
          "[resourceId(''Microsoft.Web/Sites'', ''' + $AppServiceSite.name + ''')]"
        ],
        "properties":' + `
        $properties + `
      '}
    '
    return ConvertFrom-Json $json
}

function Get-SpqAppServicAuthSettings {
    Param(
        [parameter(Mandatory = $true)] [object] $AppServiceSite,
        [parameter(Mandatory = $true)] [string] $AppRegistrationClientId,
        [parameter(Mandatory = $true)] [string] $Issuer
    )

    $json = '
    {
        "name": "authsettings",
        "type": "config",
        "apiVersion": "2019-08-01",
        "dependsOn": [
          "[resourceId(''Microsoft.Web/Sites'', ''' + $AppServiceSite.name + ''')]"
        ],
        "properties": {
          "enabled": true,
          "unauthenticatedClientAction": "RedirectToLoginPage",
          "tokenStoreEnabled": true,
          "defaultProvider": "AzureActiveDirectory",
          "clientId": "' + $AppRegistrationClientId + '",
          "issuer": "' + $Issuer + '"
        }
    }
    '
    return ConvertFrom-Json $json
}

