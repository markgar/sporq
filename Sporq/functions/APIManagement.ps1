function Get-SpqApimConsumptionInstance {
    Param(
        [parameter(Mandatory = $true)] [string] $ApplicationCode,
        [parameter(Mandatory = $true)] [string] $EnvironmentName,
        [parameter(Mandatory = $true)] [string] $Location,
        [parameter(Mandatory = $false)] [string] $UniqueNamePhrase = $null,
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [string] $PublisherEmail,
        [parameter(Mandatory = $true)] [string] $PublisherName
    )
    
    $apimName = Get-SpqResourceName `
        -ApplicationCode $ApplicationCode `
        -EnvironmentName $EnvironmentName `
        -UniqueNamePhrase $UniqueNamePhrase `
        -ServiceTypeName "Microsoft.ApiManagement/service" `
        -Location $Location

    $json = '
    {
        "type": "Microsoft.ApiManagement/service",
        "apiVersion": "2019-01-01",
        "name": "' + $apimName + '",
        "location": "' + $Location + '",
        "sku": {
            "name": "Consumption",
            "capacity": 0
        },
        "properties": {
            "publisherEmail": "' + $PublisherEmail + '",
            "publisherName": "' + $PublisherName + '",
            "notificationSenderEmail": "apimgmt-noreply@mail.windowsazure.com",
            "hostnameConfigurations": [
                {
                    "type": "Proxy",
                    "hostName": "' + $apimName + '.azure-api.net",
                    "negotiateClientCertificate": false,
                    "defaultSslBinding": true
                }
            ],
            "customProperties": {
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10": "False",
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11": "False",
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10": "False",
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11": "False",
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30": "False",
                "Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2": "False"
            },
            "virtualNetworkType": "None"
        }
    }
    '
    return ConvertFrom-Json $json
}

function Get-SpqApimPolicy {
    Param(
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $APIMInstance
    )

    $json = '
    {
        "type": "Microsoft.ApiManagement/service/policies",
        "apiVersion": "2019-01-01",
        "name": "' + $APIMInstance.name + '/policy",
        "dependsOn": [
            "[resourceId(''Microsoft.ApiManagement/service'', ''' + $APIMInstance.name + ''')]"
        ],
        "properties": {
            "value": "<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound></inbound>\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound></outbound>\r\n</policies>",
            "format": "xml"
        }
    }
    '
    return ConvertFrom-Json $json
}

function Get-SpqApimSubscription {
    Param(
        [string] $ExceptionGuid,
        [parameter(Mandatory = $true)] [object] $APIMInstance
    )

    $json = '
    {
        "type": "Microsoft.ApiManagement/service/subscriptions",
        "apiVersion": "2019-01-01",
        "name": "' + $APIMInstance.name + '/master",
        "dependsOn": [
            "[resourceId(''Microsoft.ApiManagement/service'', ''' + $APIMInstance.name + ''')]"
        ],
        "properties": {
            "scope": "[concat(resourceId(''Microsoft.ApiManagement/service'', ''' + $APIMInstance.name + '''), ''/'')]",
            "displayName": "Built-in all-access subscription",
            "allowTracing": true
        }
    }
    '
    return ConvertFrom-Json $json
}