# Governance Assumptions
- Sandbox, Non-Prod, Prod environments (subscriptions)
- Sandbox allows anyone to create RG, as long as they provide enough information to bill them and to remind them of a budget
- Tagging at the RG level, pushed down with Azure Policy
- No one has standing contributor access in non-prod and prod.
- All deployments must happen through automated pipelines.
- Decide on your required tags.  At least costcenter - or whatever you need to do cost management
- Implement "Inherit a tag from the resource group" policy on those tags.
- Implement "Require specified tag on resource groups" on those tags.