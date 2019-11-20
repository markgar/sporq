# Naming Convention
Sporq includes a built-in naming convention and ensures readability, searchability, and resource uniqueness.

By default it inlcludes 5 parts:
Application Code
Environment
Resource Type
Name Fragement
Azure Region

**Application Code** is ment to uniquely identify the application being deployed.  This allows for a short abbreviation that uniqely represents 
every application.  This should be assigned through an easily accessible service in the organization.  These codes could be 3 or 4 characters long.  Having this code allows for easy reporting across all environments.  Since environment is usually a three letter abbreviation, maybe make this have to include a number or maybe be 4 characters long.  That way you don't end up with an application code that is 'dev'.

**Environment** is meant to represent the environment such as Development, Test, Production.  Try using a 3 letter abbreviaion such as dev, tst, prd.  This also allows easy reporting and searching for all resources in a certain environment.

**Resource Type** is an abbreviation of the Azure resource type.  This allows for easy identification of each service.

**Name Fragment** allows us to have two of the same resource type in a resource group, but differentiate between them.  For instance, an application that has 2 App Services Websites, one for the WebUI and one for the API layer would be able to use this fragment of the naming convention to name them differently.  This is not required on any of the services when creating them.  This should be used when this situation comes up.

**Azure Region** is useful in the naming convention because the same application infrastructure will possibly be deployed into multiple regions for HA/DR purposes.

The built in naming convention is defined as follows:
    Suggestions:
    applicationcode-environment-resourcetype-additionalname-location
    this sorts the similar resource types together first, then location
    q4k-dev-usc-site-web
    q4k-dev-usc-site-api
    q4k-dev-use2-site-web
    q4k-dev-use2-site-api

    applicationcode-environment-location-resourcetype-additionalname
    this sorts everything in the same location first, then resource type
    example: web and api app, each deployed in usc and use2
    q4k-dev-site-api-usc
    q4k-dev-site-web-usc
    q4k-dev-site-api-use2
    q4k-dev-site-web-use2