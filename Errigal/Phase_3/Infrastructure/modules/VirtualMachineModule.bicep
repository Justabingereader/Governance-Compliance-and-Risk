param appSpokeSubnetId string
param tags object
param sshPublicKey string
param adminUsername string

resource NetworkInterfaceCard 'Microsoft.Network/networkInterfaces@2024-10-01' = {
  name: 'nic-errigal-vm-neu'
  location: resourceGroup().location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: appSpokeSubnetId
          }
        }
      }
    ]
  }
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: 'vm-errigal-neu'
  location: resourceGroup().location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2as_v2'
    }
    osProfile: {
      computerName: 'vm-errigal-neu'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NetworkInterfaceCard.id
        }
      ]
    }
  }
}
