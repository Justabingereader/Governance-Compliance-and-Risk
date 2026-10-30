targetScope = 'subscription'

param hubAddressPrefix string
param hubSubnetAddressPrefix string
param appSpokeAddressPrefix string
param appSpokeSubnetAddressPrefix string
param appSpokeSubnetAddressPrefix2 string
param dataSpokeAddressPrefix string
param dataSpokeSubnetAddressPrefix string
param PrivateHubEndpointSubnetAddressPrefix string

@description('Tags shared by resources, including the required governance tags.')
param commonTags object
@description('Tags specific to the network module. These override common tags with matching keys.')
param networkTags object
@description('Tags specific to the Key Vault module.')
param keyVaultTags object

@description('Name of the custom policy initiative.')
param initiativeName string
@description('Display name of the custom policy initiative.')
param initiativeDisplayName string
@description('Description of the custom policy initiative.')
param initiativeDescription string
@description('Name of the policy assignment.')
param assignmentName string
@description('Display name of the policy assignment.')
param assignmentDisplayName string
@description('Description of the policy assignment.')
param assignmentDescription string
@description('Allowed App Service Plan SKU tiers.')
param allowedServerFarmTiers string[]
@description('Allowed managed disk SKU names.')
param allowedDiskSkus string[]
@description('SKU pattern allowed for virtual machines.')
param allowedVmSku string
@description('SKU pattern allowed for virtual machine scale sets.')
param allowedVmScaleSetSku string
@description('Resource location allowed by the region policy.')
param allowedLocation string
@description('Allowed values for the cost centre tag.')
param allowedCostCentreTagValues string[]
@description('Allowed values for the owner tag.')
param allowedOwnerTagValues string[]
@description('Allowed values for the data classification tag.')
param allowedDataClassTagValues string[]

@description('Monthly budget amount.')
param budgetAmount int
@description('Budget period start date.')
param startDate string
@description('Budget period end date.')
param endDate string
@description('Minimum budget threshold percentage.')
param minimumThreshold int
@description('Average budget threshold percentage.')
param averageThreshold int
@description('Maximum budget threshold percentage.')
param maximumThreshold int
@description('Email addresses that receive budget threshold notifications.')
param contactEmails string[]

module GovernanceBaseline './modules/Governance_class_baseline.bicep' = {
  name: 'GovernanceBaseline'
  scope: subscription()
  params: {
    initiativeName: initiativeName
    initiativeDisplayName: initiativeDisplayName
    initiativeDescription: initiativeDescription
    assignmentName: assignmentName
    assignmentDisplayName: assignmentDisplayName
    assignmentDescription: assignmentDescription
    allowedServerFarmTiers: allowedServerFarmTiers
    allowedDiskSkus: allowedDiskSkus
    allowedVmSku: allowedVmSku
    allowedVmScaleSetSku: allowedVmScaleSetSku
    allowedLocation: allowedLocation
    allowedCostCentreTagValues: allowedCostCentreTagValues
    allowedOwnerTagValues: allowedOwnerTagValues
    allowedDataClassTagValues: allowedDataClassTagValues
  }
}

module Budgets './modules/Budgets.bicep' = {
  name: 'Budgets'
  scope: resourceGroup('Errigal')
  params: {
    budgetAmount: budgetAmount
    startDate: startDate
    endDate: endDate
    minimumThreshold: minimumThreshold
    averageThreshold: averageThreshold
    maximumThreshold: maximumThreshold
    contactEmails: contactEmails
  }
}

module Network './modules/Network.bicep' = {
  name: 'Network'
  scope: resourceGroup('Errigal')
  params: {
    tags: union(commonTags, networkTags)
    hubAddressPrefix: hubAddressPrefix 
    hubSubnetAddressPrefix: hubSubnetAddressPrefix
    appSpokeAddressPrefix: appSpokeAddressPrefix
    appSpokeSubnetAddressPrefix: appSpokeSubnetAddressPrefix
    appSpokeSubnetAddressPrefix2: appSpokeSubnetAddressPrefix2
    dataSpokeAddressPrefix: dataSpokeAddressPrefix
    dataSpokeSubnetAddressPrefix: dataSpokeSubnetAddressPrefix
    PrivateHubEndpointSubnetAddressPrefix: PrivateHubEndpointSubnetAddressPrefix
  }
}

module KeyVault './modules/KeyVault.bicep' = {
  name: 'KeyVault'
  scope: resourceGroup('Errigal')
  params: {
    tags: union(commonTags, keyVaultTags)
    PrivateHubEndpointSubnetId: Network.outputs.PrivateHubEndpointSubnetId
  }
}
