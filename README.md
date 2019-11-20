# Sporq

Sporq is an object based ARM Template generator.  Its purpose to make ARM templates creation programmatic,
include a resource naming convention, make resource access key refreshment easy, because Sporq outputs 
ARM templates that are completely ready to deploy, make those ARM templates as test-able as possible.

Its purpose is to use PowerShell as the ARM template programming language (rather than the ARM Template expression language) 
to output ARM templates that are completely ready to deploy without using ARM template parameters or variables.  
This means a new paradigm for writing ARM templates:
- Use a programmatic language like PowerShell that hides the complexity of ARM template syntax
- Implememnt a naming convention with Sporq for your Resource Groups as well as Resources
- Refresh secrets with with simple scripts included with Sporq
- Implement cost management using Azure Cost Analytics and Azure Budgets using Resource Group creation in Sporq
- Easily test ARM templates for enterprise security requirements becuase there are no variables and parameters

## Installation

If you have the [PowerShellGet](https://msdn.microsoft.com/powershell/gallery/readme) module installed
you can enter the following command:

```PowerShell
Install-Module Sporq
```

Alternatively you can download a ZIP file of the latest version from our [Releases](https://github.com/markgar/sporq/releases)
page.

## Documentation

You can learn how to use Sporq to write your own ARM templates by reading our documentation:

- [Introduction to Sporq](docs/Introduction.md)
- [Getting Started](docs/GettingStarted.md)
- [Refreshing Keys](docs/RefreshingKeys.md)
- [Testing Your Templates](docs/Testing.md)
- [Managing Resource Group Creation](docs/ResourceGroups.md)
- [Naming Convention](NamingConvention.md)
- [Customizing Sporq for your enterprise](CustomizeSporq.md)
- [Cmdlet Documentation]()

Or by watching:

- [Working with Plaster Presentation](https://youtu.be/16CYGTKH73U) by David Christian - [@dchristian3188](https://github.com/dchristian3188)

## Maintainers

- [Mark Garner](https://github.com/markgar) - [@mgarner](http://twitter.com/mgarner)

## License

This project is [licensed under the MIT License](LICENSE).