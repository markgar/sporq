# Introduction 
**Sporq** is a governance framework that includes things like a programmatic way to [create arm templates](doc/GettingStarted.md), a [naming convention](doc/NamingConvention.md), [secret managemnt and rotation](doc/RefreshingKeys.md) right from the start, [cost management](doc/ResourceGroups.md) by default, and a framework to [security-test arm templates](doc/Testing.md) before they are deployed.

**Sporq** is for you if:
- You want to get going fast and don't mind using a governance strategy that is _pre-built_ (it is ready go right now - no changes needed), _opinionated_ (there is a certian way of doing things), and _prescriptive_ (focused on getting things done rather than discussing options)
- Your skillset doesn't include arm template creation
- You want to store secrets in Key Vault by default and rotate them regularly
- You want to follow a naming convention
- You think cost governanace is an important part of utilizing the cloud
- You want to perform 'unit tests' on arm templates to ensure security and policy adherence as earely as possible in the development cycle: during the build phase.

# Getting to know Sporq
**Sporq** is a powershell library delivered to you via a public [nuget.org](https://www.nuget.org/packages/Sporq/) package that makes the creation and testing of arm templates easier.  You'll declare variables and use pre-built functions to retrieve arm template fragments.  These fragments can be aggregated together to create an arm template object that can be finally exported to a ready-to-deploy arm template json file.

By the way - there are two ways to use **Sporq**.  The quickest is to use the public nuget package.  This includes template fragemnts and tests that are ready to go.  But if you'd like to customize these artifacts, you can do that too.  See [Customizing Sporq for Your Enterprise](doc/CustomizeSporq.md).

When you use **Sporq**, you first retrieve an object that represents and empty arm template.
```powershell
# Create an empty base arm template
$baseTemplate = Get-BaseTemplate
```

This function, `Get-BaseTemplate` is profided by the framework and returns an object.

The next thing is to retrieve an object that represents the infrastructure you'd like to add to the arm template.
```powershell
# Create a storage account fragment
$aStorageAccount = Get-StorageTemplateFragment -CommonProperties $commonProperties -Location "centralus" -StorageAccessTier "Standard_RAGRS" -StorageTier "Standard"
```

Now that you have the Azure Storage Accont object, you add it to your base template like this:
```powershell
# Add it to the template
$baseTemplate.resources += $aStorageAccount
```

There are more functions like `Get-StorageTemplateFragment` for other objects such as `Get-EventHubNamespaceTemplateFragment`.  You'll also use `Get-KeyVaultTemplateFragment` to create a Key Vault where you can store secrets.  You can learn how to do this with **Sporq** by reading [Storing Secrets in Key Vault](doc/RefreshingKeys.md).

Because of the way Sporq convention works, it is easy to use this both on your local machine, and also in an Azure Dev Ops pipeline.  You'll learm more about how the boilerplate code works to enable this convention.  If you want to customize the arm template fragments or the tests that inside Sporq, see [Custimizing Sporq for Your Enterprise](doc/CustomizeSporq.md).

# More Cool Stuff
- If you'd like to get going with **Sporq**, check out the [Getting Started](doc/GettingStarted.md) document.  
- Sporq makes it easy to refresh keys in your resources.  See the [Refreshing Keys](doc/RefreshingKeys.md) document for more information. 
- If you want to know more about how **Sporq** enables testing - including security testing, check out [Testing Your Templates](doc/Testing.md).  
- **Sporq** is part of a larger governance strategey.  If you'd like to know more, check out [Governance Strategy](doc/GovernanceStrategy.md).  
- If you'd like to contribute, check out [Contributions](doc/Contributions.md).  
- If you're interested in customizing Sporq to suit your enterprise needs, this is straight forward.  You can can create your own private nuget package with templates customized by you with tests customized by you.  You can check out more on how to do this at [Customizing Sporq for Your Enterprise](doc/CustomizeSporq.md). 