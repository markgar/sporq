
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
$templateJson = $baseTemplate | ConvertTo-Json -Depth 10

# write the json string out to file
$templateJson | Out-File -FilePath $TemplateOutputPath