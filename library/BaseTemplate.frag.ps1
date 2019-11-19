
function Get-SpqBaseTemplate {
    Param()

    $json = '
    {
        "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {},
        "variables": {},
        "resources": []
    }
    '

    return ConvertFrom-Json $json
}