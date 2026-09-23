targetScope = 'subscription'

@description('Name of the existing resource group for the managed identities.')
param IdentityResourceGroupName string = 'Errigal'

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

@description('Stable seed used to generate the custom role definition name.')
param customRoleId string = 'CustomRoleID'

@description('Stable seed used to generate the custom role assignment name.')
param customRoleAssignmentId string = 'CustomRoleAssignmentV3'

resource identityResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: IdentityResourceGroupName
}

module identityResources './IdentityResources.bicep' = {
  name: 'identityResources'
  scope: identityResourceGroup
  params: {
    identityConfigurations: identityConfigurations
  }
}

resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  scope: subscription()
  name: guid(subscription().id, customRoleId)
  properties: {
    roleName: 'Custom Role'
    description: 'This is a custom role with specific permissions.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Authorization/policyAssignments/*'
          'Microsoft.Authorization/policyDefinitions/*'
          'Microsoft.Authorization/policySetDefinitions/*'
          'Microsoft.Consumption/budgets/*'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

resource customRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (identity, index) in identityConfigurations: {
  scope: subscription()
  name: index == 0
    ? guid(subscription().id, customRoleId, customRoleAssignmentId)
    : guid(subscription().id, customRoleId, customRoleAssignmentId, identity.identityName)
  properties: {
    roleDefinitionId: customRole.id
    principalId: identityResources.outputs.managedIdentityPrincipalIds[index]
    principalType: 'ServicePrincipal'
  }
}]
