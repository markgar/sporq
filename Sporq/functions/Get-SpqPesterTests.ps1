function Get-SpqPesterTests {
    param (
        [Parameter(Mandatory = $true)] [string]$OutputPath 
    )
    $files = 'AppServiceWebsite.Tests.ps1', 'Storage.Tests.ps1'
    foreach ($file in $files)
    {
        $path = "./Sporq/tests/" + $file
        Get-Content $path | Out-File $OutputPath+$file
    }
}
