function Get-SpqAppServiceWebSiteTests {

    $testCode = '
param (
    [Parameter(Mandatory = $true)]
    [string]$TemplatePath 
)

# load text of arm template
$templateARM = Get-Content $TemplatePath -Raw -ErrorAction SilentlyContinue

# load template into object
$template = ConvertFrom-Json -InputObject $templateARM -ErrorAction SilentlyContinue


# choose which type of arm template resource we will test here
# EDIT THIS FOR EACH PESTER TESTS FILE *****************************************
$resourceTypeToTest = "Microsoft.Web/sites"

# select only resources in the arm template that are of this type
$resourcesToTest = $template.resources | Where-Object { $_.type -eq $resourceTypeToTest }


# loop through these items
foreach ($resource in $resourcesToTest) {
    $exceptionArray = New-Object System.Collections.Generic.List[System.Object]

    foreach ($metadataItem in $resource.metadata.PSObject.Properties ) {
        if ($metadataItem.Name.StartsWith("exceptionGuid")) {
            $exceptionArray.Add($metadataItem.Value)
        }
    }

    Describe "Micrsoft/Storage Validation" {
  
        Context "Security Tests" {
      
            if (!$exceptionArray.Contains("3381100b-f753-4653-aea2-8fd117acfa57")) {
                It "Requires Https on to be true" {
                    $expectedValue = $true
                    $templateProperty = $resource.properties.httpsOnly
                    $templateProperty | Should Be $expectedValue
                }
            }
            else {
                It "Requires Https on to be true {{{Excepted}}}" {
                    1 | Should Be 1
                }     
            }


        }
      
    }
}
'
return $testCode
}