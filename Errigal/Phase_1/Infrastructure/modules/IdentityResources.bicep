targetScope = 'resourceGroup'

type identityConfiguration = {
  identityName: string
  tags: {
    costCentre: string
    owner: string
    dataClass: string
  }
  federatedCredentialName: string
  federatedCredentialIssuer: string
  federatedCredentialSubject: string
  federatedCredentialAudiences: string[]
}

@description('User-assigned managed identities and their federated credential settings.')
param identityConfigurations identityConfiguration[]

resource managedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = [for identity in identityConfigurations: {
  name: identity.identityName
  location: resourceGroup().location
  tags: identity.tags
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
