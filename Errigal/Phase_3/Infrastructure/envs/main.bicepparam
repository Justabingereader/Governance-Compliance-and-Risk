using '../main.bicep'

param hubAddressPrefix = '10.10.1.0/24'
param hubSubnetAddressPrefix = '10.10.1.0/27'
param PrivateHubEndpointSubnetAddressPrefix = '10.10.1.32/27'
param appSpokeAddressPrefix = '10.10.2.0/24'
param appSpokeSubnetAddressPrefix = '10.10.2.0/27'
param appSpokeSubnetAddressPrefix2 = '10.10.2.32/27'
param dataSpokeAddressPrefix = '10.10.3.0/24'
param dataSpokeSubnetAddressPrefix = '10.10.3.0/27'
param commonTags = {
	costCentre: 'IT'
	owner: 'Admin'
	dataClass: 'internal'
}
param networkTags = {
}

param keyVaultTags = {
	costCentre: 'IT'
	owner: 'Admin'
	dataClass: 'protected'
}

param VMTags = {
	costCentre: 'IT'
	owner: 'Admin'
	dataClass: 'internal'
}

param sshPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDViUw1wioyVNdvRuw/vxkgukLa1m/yOeacUgCOMG+5JNVDYvBFRh/fCk+4joimPd/+i1WsmOUE9e/XzA+WbABrDOU58sVO7r07TsHsEG2JE3ba2GSLkU0PzIVoACD2EU1LRNS8szvIWyFB50k3rGkBBcVIj2SN+L8EOMSmhXTKfjUBS+4tk7nbTEpJ/KCu3KPxezZQDBqwvRy6JBxresEqer1InBfqKVJ30/OzElXgLAiT6p6jM+GfHqGmHhENRuTGgT/pjlDF1zWdlToiHR9OczN+mtQwpMlbww4aT9CUrCE8eT3KI8N4k3jrBIebLQCzi85yNAkbonOMz9bRUhHU9ple8zZaLh0j4AXO3PFTZvDPhCiIKQ0g4vhp8TgNhIUBIpxIaTL8iWuaYxYXHnTWurhksMo1+XRqkf0eZqtVZeFEOruDKb+RPnooRtl/jVcbki2Dx349xygaM9+yhnk6CQ+M2XfK4INy0EbYixVRkVkeA5tik4iIBf57bfuesbTc2+L2MUicyXY/9uOxKv3OKXQXnst8qDDTyp26LHjIHkNTyKxxvGaujuQmzdgyeQ2XnFaTpvjsTyJOk5Ka6r+nYFFtvGr/geLhEJC/mUbRKJdn1YcnyciLci99ULq21gI8omEctD1sYNX/0mDdz0OGpaWE5wB8pVIA85/qFQbvAw== harou@SAINt'
param adminUsername = 'linuxadmin'

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
