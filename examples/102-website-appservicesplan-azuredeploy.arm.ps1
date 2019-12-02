Write-Host "Generating Template..."

$environmentName = "dev"
$applicationCode = "q4k"

# Grab an empty base template
$baseTemplate = Get-SpqBaseTemplate


$appServicesPlan = Get-SpqAppServicePlan `
    -ApplicationCode $applicationCode `
    -EnvironmentName $environmentName `
    -Location "centralus" `
    -AppServicePlanSKU "S1"
$baseTemplate.resources += $appServicesPlan


$webSite = Get-SpqAppServiceWebSite `
    -ApplicationCode $applicationCode `
    -EnvironmentName $environmentName `
    -Location "centralus" `
    -UniqueNamePhrase "web" `
    -AppServicePlan $appServicesPlan
$baseTemplate.resources += $webSite


# convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10