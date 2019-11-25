$tags = @{ 
    "env"     = $commonProperties.EnvironmentName; 
    "appcode" = $commonProperties.ApplicationCode
}

New-SpqResourceGroup -ApplicationCode "id8" -EnvironmentName "dev" `
    -Location "centralus" -Tags $tags `
    -BudgetAmount 50 -BudgetAlertEmailAddresses "someone@something.com,someoneelse@something.com"