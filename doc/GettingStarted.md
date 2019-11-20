# Getting Started with Sporq
Getting started with **Sporq** is easy.  It is delivered as a [PowerShell Gallery Module](https://www.powershellgallery.com/packages/Sporq/).  If you've never used the PowerShell Gallery, you might need to install [PowerShellGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-6) which allows you to pull modules from the PowerShell Gallery.

After you have installed PowerShellGet, open a PowerShell prompt and run:
```powershell
Install-Module -Name 'Sporq'
```

Once you've done this, you'll be ready to being writing Sporq code.

Create a file called ```create-arm-template.ps1```
Add this code to the file:
```powershell
# Declare your common properties
$commonProperties = Get-SpqCommonProperties
$commonProperties.EnvironmentName = "dev"
$commonProperties.ApplicationCode = "q4k"

# Create an empty base template
$baseTemplate = Get-SpqBaseTemplate

# Create a storage account fragment
$myStorageAccount = Get-SpqStorageAccount -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_RAGRS" -StorageTier "Standard"

# Add it to the template
$baseTemplate.resources += $myStorageAccount

# Convert the template object to a json string
$baseTemplate | ConvertTo-Json -Depth 10
```

You should be able to run this now by running ```./create-arm-template.ps1``` or ```.\create-arm-template.ps1``` depending on your platform.
This should output the json of the ARM template.

# More Examples
Check the [examples](/examples) directory for additional samples.