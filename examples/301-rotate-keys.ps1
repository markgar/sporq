# reference your resource group
$resourceGroupName = "myResourceGroup"

# run the Key Rotation function from the Sporq library      
Install-NewKeys -ResourceGroupName $resourceGroupName -KeyName "Secondary"