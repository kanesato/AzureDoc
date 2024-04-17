// - - - preconditions - - - 
// - - - - - - - - - - - - -
//All resources will be deployed in the resource group called "Bicep-fundermental-resourcegroup"
//All states like location will be inherited from the resource group
// - - - - - - - - - - - - -

// - - - Paremeters defination - - - 
param location string = resourceGroup().location
//param location string = 'japaneast'

// - - - Hub Virtual Network - - - 
param vnetNameHub string = 'poc-Hub-Vnet'
param ipAddressPrefixHub array = ['10.0.0.0/16']

// - - - Spoke Virtual Network - - - 
param vnetNameSpk string = 'poc-Spk-Vnet-01'
param ipAddressPrefixSpk array = ['10.1.0.0/16']
param subnetName1Spk string = 'poc-spk01-subnet01'
param subnetName2Spk string = 'poc-spk01-subnet02'
param ipAddressPrefixSpk01Subnet01 string = '10.1.0.0/24'
param ipAddressPrefixSpk01Subnet02 string = '10.1.1.0/24'

// - - - Public IP - - -
param publicIpName string = 'poc-Bastion-PublicIP'
param publicIpAllocationMethod string = 'Static'
param publicIpAddressVersion string = 'IPv4'
param publicIpSkuName string = 'Standard'
param publicIpSkuTier string = 'Regional'

// - - - Bastion - - -
param bastionSubnetName string = 'AzureBastionSubnet'
param ipAddressPrefixBastionSubnet string = '10.0.0.0/26'
param bastionName string = 'poc-Bastion-Hub'

// - - - Virtual Machine - - -
param vmName string = 'poc-VM-Windows10'
param vmSize string = 'Standard_D2s_v3'

// - - - Boolean for engaging deployment - - -
// - - - true: engage / false; not engage - - -
param ExistHubVnet bool = false
param ExistSpokeVnet bool = false
param ExistVnetPeering bool = false
param ExistBastion bool = false
//-------
// 1. Create a hub virtual network
module createHubVnet './modules/1.hub-vnet.bicep' =  {
  name: 'createHubVnet'
  params: {
    location: location
    vnetName: vnetNameHub
    ipAddressPrefixes: ipAddressPrefixHub
  }
}

// 2. Create a spoke virtual network
module createSpokeVnet './modules/2.spoke-vnet.bicep' = if(ExistSpokeVnet) {
  name: 'createSpokeVnet'
  params: {
    location: location
    vnetName: vnetNameSpk
    ipAddressPrefix: ipAddressPrefixSpk
    subnetName1: subnetName1Spk
    subnetName2: subnetName2Spk
    subnetPrefix1: ipAddressPrefixSpk01Subnet01
    subnetPrefix2: ipAddressPrefixSpk01Subnet02
  }
}

// 3. Create a virtual network peering between the hub and spoke virtual networks
module createVnetPeering './modules/3.vnetPeering.bicep' = if(ExistVnetPeering) {
  name: 'createVnetPeering'
  params: {
    vnetNameHub: createHubVnet.outputs.hubVnetName
    vnetNameSpk: createSpokeVnet.outputs.spkVnetName
    vnetHubVnetID:createHubVnet.outputs.hubVnetId
    vnetSpkVnetID:createSpokeVnet.outputs.spkVnetId
  }
}

/*
// 4. create a subvnet in a virtual network
module createSubvnet './modules/4.subnet.bicep' = {
  name: 'createSubvnet'
  params: {
    vnetName:createHubVnet.outputs.hubVnetName
    subnetName:bastionSubnetName
    ipAddressPrefix:ipAddressPrefixBastionSubnet
  }
}

// 5. create a public IP address
module createPublicIp './modules/5.publicIp.bicep' = {
  name: 'createPublicIp'
  params: {
  location: location
  publicIpName: publicIpName
  publicIpAllocationMethod: publicIpAllocationMethod
  publicIpAddressVersion: publicIpAddressVersion
  publicIpSkuName: publicIpSkuName
  publicIpSkuTier: publicIpSkuTier
  }
}
*/

// 4. create a bastion subnet in the hub virtual network
module createBastion './modules/4.bastion.bicep' = if(ExistBastion) {
  name: 'createBastion'
  params: {
    location: location
    vnetName: createHubVnet.outputs.hubVnetName
    subnetName: bastionSubnetName
    ipAddressPrefix:ipAddressPrefixBastionSubnet
    publicIpAllocationMethod: publicIpAllocationMethod
    publicIpAddressVersion: publicIpAddressVersion
    publicIpSkuName: publicIpSkuName
    publicIpSkuTier: publicIpSkuTier
    publicIpName: publicIpName
    bastionName: bastionName
  }
}

resource tmpSpokeVnet 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: vnetNameSpk
}

resource tmpSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: subnetName1Spk
  parent: tmpSpokeVnet
}

// Create a network interface in the subnet
resource VmWindows10Nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'VmWindows10Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpconfigNic01'
        properties: {
          subnet: {
            id: tmpSubnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// create a virtual machine in the spoke virtual network
resource vm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftVisualStudio'
        offer: 'Windows'
        sku: 'Windows-10-N-x64'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: 'adminuser'
      adminPassword: 'Rduaain08180422'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: VmWindows10Nic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

//--------------------------------------------------

/*

// Create a storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'mystorageaccount'
  location: rg.location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Create a virtual machine in the spoke virtual network
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM'
  location: rg.location
  dependsOn: [
    spokeVnet
    storageAccount
    nsg
    nic
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: 'myVMosdisk'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Create a network interface for the virtual machine
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'myNic'
  location: rg.location
  dependsOn: [
    spokeVnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myIpConfig'
        properties: {
          subnet: {
            id: spokeVnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Create a Network Security Group for the virtual machine
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'myNSG'
  location: rg.location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
        }
      }
    ]
  }
}

// Create a Bastion
resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: 'myBastion'
  location: rg.location
  dependsOn: [
    hubVnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myBastionIpConfig'
        properties: {
          subnet: {
            id: hubVnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

// Create a public IP address for the Bastion
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'myPublicIp'
  location: rg.location
  properties: {
    sku: {
      name: 'Standard'
    }
    publicIPAllocationMethod: 'Static'
  }
}

// Add the virtual machine to the Network Security Group
resource vmNSGAssociation 'Microsoft.Network/networkInterfaces/securityRules@2021-02-01' = {
  name: 'myNSGAssociation'
  dependsOn: [
    nsg
    nic
  ]
  properties: {
    networkInterface: {
      id: nic.id
    }
    securityRuleAssociations: [
      {
        securityRule: {
          id: nsg.properties.securityRules[0].id
        }
        direction: 'Inbound'
      }
    ]
  }
}


*/
