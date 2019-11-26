$environmentName = "dev"
$applicationCode = "q4k"

$tags = @{ 
    "env"     = $environmentName; 
    "appcode" = $applicationCode
}

New-SpqResourceGroup -ApplicationCode "id8" -EnvironmentName "dev" `
    -Location "centralus" -Tags $tags `
    -BudgetAmount 50 -BudgetAlertEmailAddresses "someone@something.com,someoneelse@something.com"