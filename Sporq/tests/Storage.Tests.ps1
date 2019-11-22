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
      
            It "Requires Name Length < 25 for resource: $($resource.name)" {
                $resource.name.Length -lt 25 | Should Be $true
            }
        }


        Context "Security Tests" {
     
   
            It "Requires Blob Encryption Be Turned On for resource: $($resource.name)" {
                
                # if we encounter an exception for this test in the ARM template, mark the test as Skipped
                if ($exceptionArray.Contains("c060eaba-feef-411c-b527-637f246fd781")) {
                    Set-ItResult -Skipped -Because "Exception Encountered"
                }

                $resource.properties.encryption.services.blob.enabled | Should Be $true
            }
   
            It "Requires File Encryption Be Turned On for resource: $($resource.name)" {
                $resource.properties.encryption.services.file.enabled | Should Be $true
            }


            It "Supports HTTPS Traffic Only for resource: $($resource.name)" {
                
                # if we encounter an exception for this test in the ARM template, mark the test as Skipped
                if ($exceptionArray.Contains("55f0b481-bea5-4b4f-9c93-d33b3d7cc981")) {
                    Set-ItResult -Skipped -Because "Exception Encountered"
                }

                $resource.properties.supportsHttpsTrafficOnly | Should Be $true
            }    


            It "Requires RAGRS Storage Type for resource: $($resource.name)" {

                # if we encounter an exception for this test in the ARM template, mark the test as Skipped
                if ($exceptionArray.Contains("f354adb1-429c-4c83-b6bd-de6012358b33")) {
                    Set-ItResult -Skipped -Because "Exception Encountered"
                }
                
                $resource.sku.name | Should Be "Standard_RAGRS"
            }

        }
      
    }
}
'
    return $testCode
}
