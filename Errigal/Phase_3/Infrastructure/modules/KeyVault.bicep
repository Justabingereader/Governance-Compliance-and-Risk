targetScope = 'resourceGroup'
param tags object

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
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
  }
}
