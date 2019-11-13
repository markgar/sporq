# Testing your templates
**Sporq** comes with some automated tests built in, ready to go.  They are built with a technology called Pester that provides syntax to perform assertions in Powershell and then export those test results to NUnitXml so they can be picked up by most pipeline tools, such as Azure Devops.

This means that when you run your pipeline, you'll perform 2 steps.  First is the creation of the ARM template via the PowerShell Sporq code, then test it using Pester.

When Pester runs and executes the tests, the tests load up your ARM template and look for certain values in specific places.  For instance, you can look to see if HTTPS is required on Storage accounts.  See Storage.Tests.ps1 to see this example.