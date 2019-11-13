# Using Sporq to Create Resource Groups
Sporq is able to help with both resouce creation - ARM templates to deploy infrastructure for applications, but also to deploy Resource Groups that contain those resources.

This is important because the naming convention consistency between Resource Groups and Resources enables clarity and order for items in the Azure Portal, but also provides the framework to enable consistent tagging of resources.  Resource tags are used to provide metadata about resources, including cost information.  Enabling cost analysis is a critical part of running a governed cloud environment.

# Providing Tags During Resource Group Creation
By providing tag information when the resource group is created, all resources in that resource group can be automatically tagged as they are created.  This is done using Azure Policy.

The specific policy is already defined in the Azure Policy section, but needs to be assigned to your subscription or to your root management group.  To learn more about Management Groups in Azure, check [here](https://docs.microsoft.com/en-us/azure/governance/management-groups/).

The policy to apply is called "Append tag and its value from the resource group" and some additional details about the definition of this policy can be found on [GitHub](https://github.com/Azure/azure-policy/tree/master/samples/ResourceGroup/copy-resourcegroup-tag)

You'll need to apply the policy once for each tag you need pushed from the resource group to the resource.  The default for Sporq is "env" - the environment such as dev, tst, prd - and "appcode" - the application code.  This should allow for cost reporting across the different envronments as well as across different application loads.

# Azure Budgets
Sporq also automatically creates Budgets  for your Resource Groups.  See [here](https://docs.microsoft.com/en-us/azure/cost-management/tutorial-acm-create-budgets) for more information on Budgets.

You provide the monthly budget in dollars and Sporq will create a budget to match.  Enter what you think the budget should be.  No extra dollars just in case.  This is meant to be an alert mechanism, so put exactly what you think should be spent in the Resource Group.
