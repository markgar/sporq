function Get-SpqStorageAccountTests {

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
$resourceTypeToTest = "Microsoft.Storage/storageAccounts"

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

        Context "Naming Tests" {
      
            It "Requires Name Length < 25" {
                $expectedValue = 25
                $lengthOfName = $resource.name.Length
                $assertion = $lengthOfName -lt $expectedValue
                $assertion | Should Be $true
            }
        }


        Context "Security Tests" {
     
            if (!$exceptionArray.Contains("c060eaba-feef-411c-b527-637f246fd781")) {
                It "Requires Blob Encryption Be Turned On" {
                    $expectedValue = $true
                    $templateProperty = $resource.properties.encryption.services.blob.enabled
                    $templateProperty | Should Be $expectedValue
                }
            }
            else {
                It "Requires Blob Encryption Be Turned On {{{Excepted}}}" {
                    1 | Should Be 1
                }     
            }

            It "Requires File Encryption Be Turned On" {
                $expectedValue = $true
                $templateProperty = $resource.properties.encryption.services.file.enabled
                $templateProperty | Should Be $expectedValue
            }


            if (!$exceptionArray.Contains("55f0b481-bea5-4b4f-9c93-d33b3d7cc981")) {
                It "Supports HTTPS Traffic Only" {
                    $expectedValue = $true
                    $templateProperty = $resource.properties.supportsHttpsTrafficOnly
                    $templateProperty | Should Be $expectedValue
                }      
            }
            else {
                It "Supports HTTPS Traffic Only {{{Excepted}}}" {
                    1 | Should Be 1
                }     
            }

            if (!$exceptionArray.Contains("f354adb1-429c-4c83-b6bd-de6012358b33")) {
                It "Requires RAGRS Storage Type" {
                    $expectedValue = "Standard_RAGRS"
                    $templateProperty = $resource.sku.name
                    $templateProperty | Should Be $expectedValue
                }      
            }
            else {
                It "Requires RAGRS Storage Type {{{Excepted}}}" {
                    1 | Should Be 1
                }     
            }


        }
      
    }
'
return $testCode
}
