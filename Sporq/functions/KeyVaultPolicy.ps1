function Get-SpqKeyVaultPolicy {
    Param(
        [parameter(Mandatory = $false)] [string] $ExceptionGuid,
        [parameter(Mandatory = $false)] [object] $ManagedIdentityOwningObject
    )

    $json = '
    {
        "tenantId": "[reference(concat(resourceId(''' + $ManagedIdentityOwningObject.type + ''', ''' + $ManagedIdentityOwningObject.name + '''), ''/providers/Microsoft.ManagedIdentity/Identities/default''), ''2015-08-31-PREVIEW'').tenantId]",
        "objectId": "[reference(concat(resourceId(''' + $ManagedIdentityOwningObject.type + ''', ''' + $ManagedIdentityOwningObject.name + '''), ''/providers/Microsoft.ManagedIdentity/Identities/default''), ''2015-08-31-PREVIEW'').principalId]",
        "permissions": {
          "keys": [],
          "secrets": [
            "get"
          ],
          "certificates": []
        }
      }
    '

    return ConvertFrom-Json $json
}
