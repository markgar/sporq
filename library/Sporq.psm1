# Store my current location
$pwd = Get-Location

# Change directory to the directory holding the fragments
Set-Location $PSScriptRoot

# Load up all the fragements
. ./BaseTemplate.frag.ps1
. ./AppInsights.frag.ps1
. ./AppServicePlan.frag.ps1
. ./AppServiceWebSite.frag.ps1
. ./CosmosDBAccount.frag.ps1
. ./EventHub.frag.ps1
. ./EventHubNamespace.frag.ps1
. ./KeyVault.frag.ps1
. ./KeyVaultSecret.frag.ps1
. ./NetworkInterface.frag.ps1
. ./PublicIpAddress.frag.ps1
. ./Search.frag.ps1
. ./StorageAccount.frag.ps1
. ./VirtualMachine.frag.ps1

# Set current directory back to where the script started
Set-Location $pwd