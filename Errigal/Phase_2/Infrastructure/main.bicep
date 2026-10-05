targetScope = 'subscription'

param hubAddressPrefix string
param hubSubnetAddressPrefix string
param appSpokeAddressPrefix string
param appSpokeSubnetAddressPrefix string
param appSpokeSubnetAddressPrefix2 string
param dataSpokeAddressPrefix string
param dataSpokeSubnetAddressPrefix string
param tags object

module GovernanceBaseline './modules/Governance_class_baseline.bicep' = {
  name: 'GovernanceBaseline'
  scope: subscription()
}

module Budgets './modules/Budgets.bicep' = {
  name: 'Budgets'
  scope: resourceGroup('Errigal')
}

module HubAndSpoke './modules/Hub-and-Spoke.bicep' = {
  name: 'HubAndSpoke'
  scope: resourceGroup('Errigal')
  params: {
    tags: tags
    hubAddressPrefix: hubAddressPrefix 
    hubSubnetAddressPrefix: hubSubnetAddressPrefix
    appSpokeAddressPrefix: appSpokeAddressPrefix
    appSpokeSubnetAddressPrefix: appSpokeSubnetAddressPrefix
    appSpokeSubnetAddressPrefix2: appSpokeSubnetAddressPrefix2
    dataSpokeAddressPrefix: dataSpokeAddressPrefix
    dataSpokeSubnetAddressPrefix: dataSpokeSubnetAddressPrefix
  }
}
