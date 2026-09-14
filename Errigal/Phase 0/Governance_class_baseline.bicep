targetScope = 'subscription'

resource Custominitiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'CustomInitiative'
  properties: {
    displayName: 'Custom Initiative: Governance Policies'
    description: 'An initiative that includes custom policies for governance.'
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
  name: 'CustomInitiativeAssignment'
  properties: {
    displayName: 'Custom Initiative Assignment: Governance Policies'
    description: 'Assignment of the custom initiative for governance policies.'
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
                notEquals: 'Standard_B*'
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
                notEquals: 'Standard_B*'
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
                notIn: [
                  'Free'
                  'Shared'
                  'Basic'
                ]
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
                notIn: [
                  'Standard_LRS'
                  'Premium_LRS'
                ]
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
            field: 'tags.costCentre'
            exists: false
          }
          {
            field: 'tags.owner'
            exists: false
          }
          {
            field: 'tags.dataClass'
            exists: false
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
        notEquals: 'northeurope'
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
