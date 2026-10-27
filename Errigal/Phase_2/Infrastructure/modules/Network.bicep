targetScope = 'resourceGroup'

param hubAddressPrefix string
param hubSubnetAddressPrefix string
param appSpokeAddressPrefix string
param appSpokeSubnetAddressPrefix string
param appSpokeSubnetAddressPrefix2 string
param dataSpokeAddressPrefix string
param dataSpokeSubnetAddressPrefix string
param PrivateHubEndpointSubnetAddressPrefix string

type resourceTags = {
  costCentre: 'IT' | 'Finance' | 'Governance'
  owner: 'Admin' | 'User' | 'Manager'
  dataClass: 'protected' | 'confidential' | 'internal' | 'public'
}

param tags resourceTags

resource CreateHubVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'HubSpokeVNet'
  location: resourceGroup().location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'HubSubnet'
        properties: {
          addressPrefix: hubSubnetAddressPrefix
          defaultOutboundAccess: false
        }
      }
      {
        name: 'PrivateHubEndpointSubnet'
        properties: {
          addressPrefix: PrivateHubEndpointSubnetAddressPrefix
          defaultOutboundAccess: false
         networkSecurityGroup: {
           id: NSGRULES.id
         }
         privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource CreateAppSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'AppSpokeVNet'
  location: resourceGroup().location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        appSpokeAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'AppSpokeSubnet'
        properties: {
          addressPrefix: appSpokeSubnetAddressPrefix
          defaultOutboundAccess: false
        }
      }
      {
        name: 'AppSpokeSubnet2'
        properties: {
          addressPrefix: appSpokeSubnetAddressPrefix2
          defaultOutboundAccess: false
          delegations: [
            {
              name: 'appServiceDelegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

resource CreateDataSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'DataSpokeVNet'
  location: resourceGroup().location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        dataSpokeAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'DataSpokeSubnet'
        properties: {
          addressPrefix: dataSpokeSubnetAddressPrefix
          defaultOutboundAccess: false
        }
      }
    ]
  }
}

resource CreateHubToAppSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  name: 'CreateHubToAppSpokePeering'
  parent: CreateHubVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateAppSpokeVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateAppSpokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  name: 'CreateAppSpokeToHubPeering'
  parent: CreateAppSpokeVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateHubVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateHubToDataSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  name: 'CreateHubToDataSpokePeering'
  parent: CreateHubVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateDataSpokeVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateDataSpokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  name: 'CreateDataSpokeToHubPeering'
  parent: CreateDataSpokeVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateHubVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource NSGRULES 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-errigal-hub-pe-neu'
  location: resourceGroup().location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowAppIntegrationSubnet'
        properties: {
          priority: 100
          direction: 'Inbound'
          sourcePortRange: '*'
          sourceAddressPrefix: appSpokeSubnetAddressPrefix2
          destinationAddressPrefix: PrivateHubEndpointSubnetAddressPrefix
          destinationPortRange: '443'
          protocol: 'Tcp'
          access: 'Allow'
        }
      }
      { 
        name: 'DenyAllOtherTraffic'
        properties: {
          priority: 4000
          direction: 'Inbound'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: PrivateHubEndpointSubnetAddressPrefix
          destinationPortRange: '*'
          protocol: '*'
          access: 'Deny'
        }
      }
    ]
  }
}

output hubVnetId string = CreateHubVirtualNetwork.id
output appSpokeVnetId string = CreateAppSpokeVirtualNetwork.id
output dataSpokeVnetId string = CreateDataSpokeVirtualNetwork.id
output hubSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', CreateHubVirtualNetwork.name, 'HubSubnet')
output appSpokeSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', CreateAppSpokeVirtualNetwork.name, 'AppSpokeSubnet')
output appSpokeSubnet2Id string = resourceId('Microsoft.Network/virtualNetworks/subnets', CreateAppSpokeVirtualNetwork.name, 'AppSpokeSubnet2')
output dataSpokeSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', CreateDataSpokeVirtualNetwork.name, 'DataSpokeSubnet')
