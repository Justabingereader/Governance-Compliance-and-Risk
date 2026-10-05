targetScope = 'subscription'

@description('Name of the custom policy initiative.')
param initiativeName string = 'CustomInitiative'

@description('Display name of the custom policy initiative.')
param initiativeDisplayName string = 'Custom Initiative: Governance Policies'

@description('Description of the custom policy initiative.')
param initiativeDescription string = 'An initiative that includes custom policies for governance.'

@description('Name of the policy assignment.')
param assignmentName string = 'CustomInitiativeAssignment'

@description('Display name of the policy assignment.')
param assignmentDisplayName string = 'Custom Initiative Assignment: Governance Policies'

@description('Description of the policy assignment.')
param assignmentDescription string = 'Assignment of the custom initiative for governance policies.'

@description('Allowed App Service Plan SKU tiers.')
param allowedServerFarmTiers string[] = [
  'Free'
  'Shared'
  'Basic'
]

@description('Allowed managed disk SKU names.')
param allowedDiskSkus string[] = [
  'Standard_LRS'
  'Premium_LRS'
]

@description('SKU pattern allowed for virtual machines.')
param allowedVmSku string = 'Standard_B*'

@description('SKU pattern allowed for virtual machine scale sets.')
param allowedVmScaleSetSku string = 'Standard_B*'

@description('Resource location allowed by the region policy.')
param allowedLocation string = 'northeurope'

@description('First tag name required on indexed resources.')
param requiredTagName1 string = 'costCentre'

@description('Second tag name required on indexed resources.')
param requiredTagName2 string = 'owner'

@description('Third tag name required on indexed resources.')
param requiredTagName3 string = 'dataClass'

resource Custominitiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: initiativeDescription
    policyType: 'Custom'
    metadata: {
      category: 'Governance'
    }
    policyDefinitions: [
      {
        policyDefinitionId: firewallPolicy.id
      }
      {
        policyDefinitionId: BastionPolicy.id
      }
      {
        policyDefinitionId: VMPolicy.id
      }
      {
        policyDefinitionId: VMScaleSetsPolicy.id
      }
      {
        policyDefinitionId: ServerFarmPolicy.id
      }
      {
        policyDefinitionId: DiskPolicy.id
      }
      {
        policyDefinitionId: DenyPublicIPonNICPolicy.id
      }
      {
        policyDefinitionId: RequirecostCentreownerdataClasspolicy.id
      }
      {
        policyDefinitionId: PinregionPolicy.id
      }
    ]
  }
}

resource CustominitiativeAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName
  properties: {
    displayName: assignmentDisplayName
    description: assignmentDescription
    policyDefinitionId: Custominitiative.id
  }
}

resource firewallPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'FirewallPolicy'
  properties: {
    displayName: 'Firewall Policy: Deny Azure Firewall Creation'
    description: 'Policy to deny the creation of Azure Firewalls in the subscription.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/azurefirewalls'
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource BastionPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'BastionPolicy'
  properties: {
    displayName: 'Bastion Policy: Deny Bastion Host Creation unless developer'
    description: 'Policy to deny the creation of Bastion Hosts unless the user is a developer.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/bastionHosts'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Network/bastionHosts/sku.name'
                notEquals: 'Developer'
              }
            ]
          }
        ]
          }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource VMPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'VMPolicy'
  properties: {
    displayName: 'VM Policy: Deny VM Creation Unless like standard_B series'
    description: 'Policy to deny the creation of Virtual Machines unless they are of the Standard_B series.'  
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachines'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Compute/virtualMachines/sku.name'
                notEquals: allowedVmSku
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource VMScaleSetsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'VMScaleSetsPolicy'
  properties: {
    displayName: 'VM Scale Sets Policy: Deny VM Scale Sets Creation Unless like standard_B series'
    description: 'Policy to deny the creation of Virtual Machine Scale Sets unless they are of the Standard_B series.'  
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachineScaleSets'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Compute/virtualMachineScaleSets/sku.name'
                notEquals: allowedVmScaleSetSku
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource ServerFarmPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'ServerFarmPolicy'
  properties: {
    displayName: 'App Service Plan Policy: Deny App Service Plan Creation Unless like free,shared or basic'
    description: 'Policy to deny the creation of App Service Plans unless they are of the Free, Shared, or Basic tiers.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Web/serverfarms'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Web/serverfarms/sku.tier'
                notIn: allowedServerFarmTiers
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource DiskPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'DiskPolicy'
  properties: {
    displayName: 'Disk Policy: Deny Disk Creation Unless like Standard_LRS or Premium_LRS'
    description: 'Policy to deny the creation of Managed Disks unless they are of the Standard_LRS or Premium_LRS types.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/disks'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Compute/disks/sku.name'
                notIn: allowedDiskSkus
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource DenyPublicIPonNICPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'DenyPublicIPonNICPolicy'
  properties: {
    displayName: 'Deny Public IP on NIC Policy'
    description: 'Policy to deny the creation of Network Interfaces with Public IP addresses.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/networkInterfaces'
          }
          {
            field: 'Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIPAddress.id'
            exists: true
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource RequirecostCentreownerdataClasspolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'RequirecostCentreownerdataClasspolicy'
  properties: {
    displayName: 'Require costCentre, owner, and dataClass tags on resources'
    description: 'Policy to require the presence of costCentre, owner, and dataClass tags on all resources.'
    policyType: 'Custom'
    mode: 'Indexed'
    policyRule: {
      if: {
        anyOf: [
          {
            field: 'tags.${requiredTagName1}'
            exists: false
          }
          {
            field: 'tags.${requiredTagName2}'
            exists: false
          }
          {
            field: 'tags.${requiredTagName3}'
            exists: false
          }
          {
            field: 'tags.${requiredTagName3}'
            notIn: [
              'protected'
              'confidential'
              'internal'
              'public'
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource PinregionPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'PinregionPolicy'
  properties: {
    displayName: 'Pin Region Policy: pin resources to northern europe'
    description: 'Policy to pin resources to northern europe.'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        field: 'location'
        notEquals: allowedLocation
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

output customInitiativeId string = Custominitiative.id
output customInitiativeAssignmentId string = CustominitiativeAssignment.id
