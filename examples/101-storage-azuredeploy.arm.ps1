# Grab an empty base template
$baseTemplate = Get-SpqBaseTemplate

# Create Storage Account
$myStorageAccount = Get-SpqStorageAccount -ApplicationCode "hq7" -EnvironmentName "dev"  -Location "centralus" -StorageAccessTier "Standard_LRS"
Write-Host $myStorageAccount
# Add to Template
$baseTemplate.resources += $myStorageAccount

# convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10