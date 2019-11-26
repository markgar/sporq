# Introduction 
**Sporq** is a governance framework that includes things like a programmatic way to [create arm templates](GettingStarted.md), a [naming convention](NamingConvention.md), [secret management and rotation](RefreshingKeys.md) right from the start, [cost management](ResourceGroups.md) by default, and a framework to [security-test arm templates](Testing.md) before they are deployed.

**Sporq** is for you if:
- You want to get going fast and don't mind using a governance strategy that is _pre-built_ (it is ready go right now - no changes needed), _opinionated_ (there is a certian way of doing things), and _prescriptive_ (focused on getting things done rather than discussing options)
- Your skillset doesn't include arm template creation
- You want to store secrets in Key Vault by default and rotate them regularly
- You want to follow a naming convention
- You think cost governanace is an important part of utilizing the cloud
- You want to perform 'unit tests' on arm templates to ensure security and policy adherence as early as possible in the development cycle: during the build phase.

# Getting to know Sporq
**Sporq** is a powershell library delivered to you via a public [PowerShell Gallery Module](https://www.powershellgallery.com/packages/Sporq/) that makes the creation and testing of arm templates easy.  You'll declare variables and use pre-built functions to retrieve objects representing ARM resources.  These objects can be aggregated together to create an object representing the whole ARM template that can be finally exported to a ready-to-deploy ARM template json file.

When you use **Sporq**, you first retrieve an object that represents and empty arm template.
```powershell
# Create an empty base arm template
$baseTemplate = Get-SpqBaseTemplate
```

This function, `Get-SpqBaseTemplate` is provided by the framework and returns an object.

The next step is to retrieve objects that represents the infrastructure you'd like to add to the ARM template.
```powershell
# Create a storage account fragment
$myStorageAccount = Get-SqpStorageAccount -ApplicationCode "hq7" -EnvironmentName "dev" -Location "centralus" -StorageAccessTier "Standard_RAGRS" -StorageTier "Standard"
```

Now that you have the Azure Storage Account object, you add it to your base template like this:
```powershell
# Add it to the template
$baseTemplate.resources += $myStorageAccount
```

There are more functions like `Get-SpqStorageAccount` for other objects such as `Get-SpqEventHubNamespace`.  You'll also use `Get-SpqKeyVault` to create a Key Vault where you can store secrets.  You can learn how to do this with **Sporq** by reading [Storing Secrets in Key Vault](RefreshingKeys.md).

Because of the way Sporq convention works, it is easy to use this on your local machine, in an Azure Dev Ops pipeline, as well as GitHub Actions.  If you want to customize the arm template fragments or the tests that inside Sporq, see [Custimizing Sporq for Your Enterprise](CustomizeSporq.md).

# More Cool Stuff
- If you'd like to get going with **Sporq**, check out the [Getting Started](GettingStarted.md) document.  
- Sporq makes it easy to refresh keys in your resources.  See the [Refreshing Keys](RefreshingKeys.md) document for more information. 
- If you want to know more about how **Sporq** enables testing - including security testing, check out [Testing Your Templates](Testing.md).  
- **Sporq** is part of a larger governance strategey.  If you'd like to know more, check out [Governance Strategy](GovernanceStrategy.md).  
- If you'd like to contribute, check out [Contributions](Contributions.md).  
- If you're interested in customizing Sporq to suit your enterprise needs, this is straight forward.  You can can create your own private nuget package with templates customized by you with tests customized by you.  You can check out more on how to do this at [Customizing Sporq for Your Enterprise](CustomizeSporq.md). 

# What's Next?
The next step is to [get started](GettingStarted.md).