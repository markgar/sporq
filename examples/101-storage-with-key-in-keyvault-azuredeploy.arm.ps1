Write-Host "Generating Template..."

# Declare your common properties
$commonProperties = Get-CommonProperties
$commonProperties.EnvironmentName = "dev"
$commonProperties.ApplicationCode = "q4k"

# Grab an empty base template
$baseTemplate = Get-BaseTemplate


# Create Key Vault
$keyVault = Get-SpqKeyVault -CommonProperties $commonProperties -Location "centralus" 
# Add to Template
$baseTemplate.resources += $keyVault


# Create Storage Account
$myStorageAccount = Get-SpqStorageAccount -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_LRS" -StorageTier "Standard"
# Add to Template
$baseTemplate.resources += $myStorageAccount


# Create Key Vault Secret for Storage Account Key
$storageKeyVaultSecret = Get-SpqKeyVaultSecret -CommonProperties $commonProperties -Location "centralus" -KeyVault $keyVault -KeyOwningObject $myStorageAccount
# Add to Template
$baseTemplate.resources += $storageKeyVaultSecret


# convert the template object to a json string
$templateJson = $baseTemplate | ConvertTo-Json -Depth 10

# write the json string out to file
$templateJson | Out-File -FilePath $TemplateOutputPath