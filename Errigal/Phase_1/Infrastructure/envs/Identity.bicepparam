using '../modules/Identity.bicep'

param IdentityResourceGroupName = 'Errigal'

param identityConfigurations = [
  {
    identityName: 'UAMI01'
    tags: {
      costCentre: 'IT'
      owner: 'Admin'
      dataClass: 'confidential'
    }
    federatedCredentialName: 'PrimaryIdentityFederatedCredential'
    federatedCredentialIssuer: 'https://token.actions.githubusercontent.com'
    federatedCredentialSubject: 'repo:Justabingereader@95038451/Private_Errigal@1381849569:ref:refs/heads/main'
    federatedCredentialAudiences: [
      'api://AzureADTokenExchange'
    ]
  }
  {
    identityName: 'UAMI02'
    tags: {
      costCentre: 'IT'
      owner: 'Admin'
      dataClass: 'confidential'
    }
    federatedCredentialName: 'SecondaryIdentityFederatedCredential'
    federatedCredentialIssuer: 'https://token.actions.githubusercontent.com'
    federatedCredentialSubject: 'repo:Justabingereader@95038451/Private_Errigal@1381849569:ref:refs/heads/side'
    federatedCredentialAudiences: [
      'api://AzureADTokenExchange'
    ]
  }
]

param customRoleId = 'CustomRoleID'
param customRoleAssignmentId = 'CustomRoleAssignmentV3'
