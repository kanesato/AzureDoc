using 'main.bicep'

// - - - Paremeters defination - - - 
param location = 'japaneast'
//param location string = 'japaneast'
// - - - Hub Virtual Network - - - 
param vnetNameHub = 'poc-Hub-Vnet'
param ipAddressPrefixHub = ['10.0.0.0/16']

// - - - Spoke Virtual Network - - - 
param vnetNameSpk = 'poc-Spk-Vnet-01'
param ipAddressPrefixSpk = ['10.1.0.0/16']
param subnetNameSpk01 = 'spk01-subnet01'
param ipAddressPrefixSpk01Subnet01 = '10.1.0.0/24'

// - - - Bastion / Public IP - - -
param bastionSubnetName = 'AzureBastionSubnet'
param ipAddressPrefixBastionSubnet = '10.0.0.0/26'
param bastionName = 'poc-Bastion-Hub'
param publicIpName = 'poc-Bastion-PublicIP'

param vnetExist = true
