# Declare your common properties
$commonProperties = Get-CommonProperties
$commonProperties.EnvironmentName = "dev"
$commonProperties.ApplicationCode = "q4k"

$tags = @{ 
    "env"     = $commonProperties.EnvironmentName; 
    "appcode" = $commonProperties.ApplicationCode
}

New-ResourceGroup -CommonProperties $commonProperties `
    -Location "centralus" -Tags $tags `
    -BudgetAmount 50 -BudgetAlertEmailAddresses "someone@something.com,someoneelse@something.com"