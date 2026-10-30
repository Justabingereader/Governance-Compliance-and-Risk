targetScope = 'resourceGroup'
param tags object
param PrivateHubEndpointSubnetId string

resource CreateKeyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: 'ErrigalKeyVault'
  location: resourceGroup().location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    publicNetworkAccess: 'Disabled'
  }
}

resource PrivateEndpointForKeyVault 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: 'PrivateEndpointForKeyVault'
  location: resourceGroup().location
  tags: tags
  properties: {
    subnet: {
      id: PrivateHubEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'KeyVaultConnection'
        properties: {
          privateLinkServiceId: CreateKeyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}
