function Get-SpqPesterTests {
    $content = Get-Content -Path "./tests/AppServiceWebsite.Tests.ps1"
    return $content
}