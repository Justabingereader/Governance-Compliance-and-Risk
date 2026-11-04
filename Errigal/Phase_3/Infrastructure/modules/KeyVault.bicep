targetScope = 'resourceGroup'
param tags object
param PrivateHubEndpointSubnetId string
param appSpokeVnetId string
@secure()
param testSecretValue string = newGuid()


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

resource PrivateDnsZoneForKeyVault 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
  tags: tags
}

resource VNetLinkForKeyVaultDns 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: PrivateDnsZoneForKeyVault
  name: 'VNetLinkForKeyVaultDns'
  location: 'global'
  tags: tags
  properties: {
    virtualNetwork: {
      id: appSpokeVnetId
    }
    registrationEnabled: false
  }
}

resource PrivateDnsZoneGroupForKeyVault 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  parent: PrivateEndpointForKeyVault
  name: 'PrivateDnsZoneGroupForKeyVault'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'KeyVaultDnsConfig'
        properties: {
          privateDnsZoneId: PrivateDnsZoneForKeyVault.id
        }
      }
    ]
  }
}

resource KeyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  parent: CreateKeyVault
  name: 'ErrigalSecret'
  properties: {
    value: testSecretValue
  }
}
