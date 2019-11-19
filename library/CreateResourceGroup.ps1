. ./library/_Abbreviations.ps1

function New-SpqResourceGroup {
    Param(
        [parameter(Mandatory = $true)] [object] $CommonProperties,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [parameter(Mandatory = $true)] [object] $Tags,
        [parameter(Mandatory = $true)] [string] $BudgetAmount,
        [parameter(Mandatory = $true)] [string] $BudgetAlertEmailAddresses

    )
    
    $resourceGroupName = Get-SpqResourceName `
        -CommonProperties $commonProperties `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "ResourceGroup" `
        -Location "centralus"
    
    New-AzResourceGroup -Name $resourceGroupName `
        -Location $Location -Tag $Tags


    $date = Get-Date
    $year = $date.Year
    $month = $date.Month
    $startDate = Get-Date -Year $year -Month $month -Day 1
    $startDateStr = '{0:yyyy-MM-dd}' -f $startDate

    $properties = @{
        "amount"       = "$BudgetAmount"; 
        "category"     = "cost"; 
        "timegrain"    = "monthly"; 
        "timeperiod"   = @{"startdate" = "$startDateStr" };
        "contactemail" = "$BudgetAlertEmailAddresses"
    }

    $budgetName = $resourceGroupName + "Budget"
    New-AzResource -Properties $properties -ResourceName $budgetName -ResourceType Microsoft.Consumption/budgets -ResourceGroupName $resourceGroupName -Force

}

