param location string
param vnetName string
param ipAddressPrefix array
param subnetPrefix1 string
param subnetPrefix2 string
param subnetName1 string
param subnetName2 string




resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ipAddressPrefix
    }
    subnets: [
      {
        name: subnetName1
        properties: {
          addressPrefix: subnetPrefix1
        }
      }
      {
        name: subnetName2
        properties: {
          addressPrefix: subnetPrefix2
        }
      }
    ]
  }
}

output spkVnetId string = spokeVnet.id
output spkVnetName string = spokeVnet.name
