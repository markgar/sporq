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

