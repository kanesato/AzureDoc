param location string
param vnetName string
param ipAddressPrefixes array

// Create a hub virtual network
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ipAddressPrefixes
    }
  }
}

output hubVnetId string = hubVnet.id
output hubVnetName string = hubVnet.name

