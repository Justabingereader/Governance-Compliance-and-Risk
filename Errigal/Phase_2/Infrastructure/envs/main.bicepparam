using '../main.bicep'

param hubAddressPrefix = '10.10.1.0/24'
param hubSubnetAddressPrefix = '10.10.1.0/27'
param PrivateHubEndpointSubnetAddressPrefix = '10.10.1.32/27'
param appSpokeAddressPrefix = '10.10.2.0/24'
param appSpokeSubnetAddressPrefix = '10.10.2.0/27'
param appSpokeSubnetAddressPrefix2 = '10.10.2.32/27'
param dataSpokeAddressPrefix = '10.10.3.0/24'
param dataSpokeSubnetAddressPrefix = '10.10.3.0/27'
param tags = {
	costCentre: 'IT'
	owner: 'Admin'
	dataClass: 'internal'
}

param initiativeName = 'CustomInitiative'
param initiativeDisplayName = 'Custom Initiative: Governance Policies'
param initiativeDescription = 'An initiative that includes custom policies for governance.'
param assignmentName = 'CustomInitiativeAssignment'
param assignmentDisplayName = 'Custom Initiative Assignment: Governance Policies'
param assignmentDescription = 'Assignment of the custom initiative for governance policies.'
param allowedServerFarmTiers = [
	'Free'
	'Shared'
	'Basic'
]
param allowedDiskSkus = [
	'Standard_LRS'
	'Premium_LRS'
]
param allowedVmSku = 'Standard_B*'
param allowedVmScaleSetSku = 'Standard_B*'
param allowedLocation = 'northeurope'
param allowedCostCentreTagValues = [
	'IT'
	'Finance'
	'Governance'
]
param allowedOwnerTagValues = [
	'Admin'
	'User'
	'Manager'
]
param allowedDataClassTagValues = [
	'protected'
	'confidential'
	'internal'
	'public'
]

param budgetAmount = 200
param startDate = '2026-09-01'
param endDate = '2027-09-01'
param minimumThreshold = 30
param averageThreshold = 60
param maximumThreshold = 90
param contactEmails = [
	'Harounimran04@gmail.com'
]
