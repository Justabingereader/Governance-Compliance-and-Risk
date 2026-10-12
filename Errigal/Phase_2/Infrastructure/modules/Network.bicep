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

resource CreateHubVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
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
        }
      }
      {
        name: 'PrivateHubEndpointSubnet'
        properties: {
          addressPrefix: PrivateHubEndpointSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'NetworkSecurityGroup'
        }
      }
    ]
  }
}

resource CreateAppSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
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
        }
      }
      {
        name: 'AppSpokeSubnet2'
        properties: {
          addressPrefix: appSpokeSubnetAddressPrefix2
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

resource CreateDataSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
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
        }
      }
    ]
  }
}

resource CreateHubToAppSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
  name: 'CreateHubToAppSpokePeering'
  parent: CreateHubVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateAppSpokeVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateAppSpokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
  name: 'CreateAppSpokeToHubPeering'
  parent: CreateAppSpokeVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateHubVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateHubToDataSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
  name: 'CreateHubToDataSpokePeering'
  parent: CreateHubVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: CreateDataSpokeVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
  }
}

resource CreateDataSpokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
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
  name: 'NSGRULES'
  location: resourceGroup().location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowAppIntegrationSubnet'
        properties: {
          priority: 100
          direction: 'Inbound'
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
