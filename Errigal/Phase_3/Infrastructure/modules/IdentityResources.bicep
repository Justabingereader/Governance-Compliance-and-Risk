targetScope = 'resourceGroup'

type identityConfiguration = {
  identityName: string
  tags: object
  federatedCredentialName: string
  federatedCredentialIssuer: string
  federatedCredentialSubject: string
  federatedCredentialAudiences: string[]
}

@description('User-assigned managed identities and their federated credential settings.')
param identityConfigurations identityConfiguration[]

@description('Tags shared by all managed identities.')
param commonTags object

resource managedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = [for identity in identityConfigurations: {
  name: identity.identityName
  location: resourceGroup().location
  tags: union(commonTags, identity.tags)
}]

resource federatedCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = [for (identity, index) in identityConfigurations: {
  parent: managedIdentities[index]
  name: identity.federatedCredentialName
  properties: {
    audiences: identity.federatedCredentialAudiences
    issuer: identity.federatedCredentialIssuer
    subject: identity.federatedCredentialSubject
  }
}]

output managedIdentityPrincipalIds string[] = [
  managedIdentities[0].properties.principalId
  managedIdentities[1].properties.principalId
]
output managedIdentityResourceId string = managedIdentities[0].id
