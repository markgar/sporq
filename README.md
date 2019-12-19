# Sporq

Sporq: the multi-tool for resource governance in Azure.  Use Powershell to emit ARM templates to enable a new level of reusability, composability, and testability.

[![Sporq Build Status](https://github.com/markgar/sporq/workflows/Create%20Module,%20Push%20to%20Powershell%20Gallery/badge.svg)](https://github.com/markgar/sporq/actions?query=workflow%3A%22Create+Module%2C+Push+to+Powershell+Gallery%22)




Sporq three main facets:
- An object based ARM Template generator
- PowerShell implementation of automated Azure Resource Key Refreshment
- PowerShell implementation of automated and governed self-service Resource Group creation process

Its purpose is to use PowerShell as the ARM template programming language (rather than the ARM Template expression language) 
to output ARM templates that are completely ready to deploy because it does not use ARM template parameters or variables.  
This means a new paradigm for writing ARM templates:
- Use a programmatic language like PowerShell simplifies ARM template definition while hiding the complexity of ARM template syntax
- Simplify the process of implememnting a naming convention for your Resource Groups as well as Resources
- Set up automated Resource Key refreshment using Sporq
- Deploy cost management across your Azure deployments using Azure Cost Analytics and Azure Budgets
- Easily test ARM templates for enterprise security requirements during the build phase of infrastructure deployment

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
- [Naming Convention](docs/NamingConvention.md)
- [Customizing Sporq for your enterprise](docs/CustomizeSporq.md)
- [Cmdlet Documentation]()

Or by watching:

- Anyone feel like a video would be helpful?

## Maintainers

- [Mark Garner](https://github.com/markgar) - [@mgarner](http://twitter.com/mgarner)

## License

This project is [licensed under the MIT License](LICENSE).
