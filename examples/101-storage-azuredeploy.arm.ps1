
# Declare your common properties
$commonProperties = Get-CommonProperties
$commonProperties.EnvironmentName = "dev"
$commonProperties.ApplicationCode = "q4k"

# Grab an empty base template
$baseTemplate = Get-BaseTemplate

# Create Storage Account
$myStorageAccount = Get-SpqStorageAcount -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_LRS" -StorageTier "Standard"

# Add to Template
$baseTemplate.resources += $myStorageAccount

# convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10