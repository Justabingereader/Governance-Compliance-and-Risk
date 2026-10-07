using '../main.bicep'

param hubAddressPrefix = '10.10.1.0/24'
param hubSubnetAddressPrefix = '10.10.1.0/27'
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
param startDate = '2026-09-01'
