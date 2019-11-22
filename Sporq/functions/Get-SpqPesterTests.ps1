function Get-SpqPesterTests {
    param (
        [Parameter(Mandatory = $true)] [string]$OutputPath 
    )
    Get-SpqStorageAccountTests | Out-File $OutputPath"StorageAccount.Tests.ps1"
    Get-SpqAppServiceWebSiteTests | Out-File $OutputPath"AppServiceWebSite.Tests.ps1"
}
