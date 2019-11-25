Write-Host "Generating Template..."

$environmentName = "dev"
$applicationCode = "q4k"

# Grab an empty base template
$baseTemplate = Get-SpqBaseTemplate


# Create Key Vault
$keyVault = Get-SpqKeyVault -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus" 
# Add to Template
$baseTemplate.resources += $keyVault


# Create Storage Account
$myStorageAccount = Get-SpqStorageAccount -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus" -StorageAccessTier "Standard_LRS"
# Add to Template
$baseTemplate.resources += $myStorageAccount


# Create Key Vault Secret for Storage Account Key
$storageKeyVaultSecret = Get-SpqKeyVaultSecret -ApplicationCode $applicationCode -EnvironmentName $environmentName -Location "centralus" -KeyVault $keyVault -KeyOwningObject $myStorageAccount
# Add to Template
$baseTemplate.resources += $storageKeyVaultSecret


# convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10