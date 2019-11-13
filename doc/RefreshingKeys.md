# Key Rotation
Sporq includes a strategy for key rotation.  Because of the conventions included in Sporq, key rotation for Azure resources such as Cosmos DB, Event Hub, and Storage can be done using a single script.

## Two Keys
Azure resources such as Storage have two keys to enable key rotation without downtime.  You refresh a key, then publish it to the Key Vault for applications to begin using.  Applications are responsible for checking the Key Vault to refresh the key they are using for resource access before that key is refreshed.

Let's assume that keys are being refreshed every week on Sundays.  On the first Sunday the Primary key is refreshed and published to Key Vault.  Applications are set to retrieve keys from Key Vault every 6 hours.  That means that withing 6 hours of refreshing the Primary key, application should retrieve the new key from Key Vault.  All the time, the Secondary key, which was in use last week, is still working.  On the second Sunday, the Seconday key is refreshed and pushed to Key Vault.  Within 6 hours the application should retrieve the refreshed key.

Every key is available for 2 weeks after it is refreshed.  The first week it is the key that is being used by the application.  The second week it is available to overlap to ensure that the application does not experience down time.

## Script
Loop through all resources to look for Key Vault

Loop through all resources again to rotate keys.

