az network bastion delete --name 'poc-Bastion-Hub' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02'
az network public-ip delete --name 'poc-Bastion-PublicIP' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02'

az network vnet delete --name 'poc-Hub-Vnet' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02'
az network vnet delete --name 'poc-Spk-Vnet-01' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02'


#az vm nic remove --vm-name 'VM' --resource-group 'Bicep-fundermental-resourcegroup' --nics 'myNic' --subscription 'skaneshiro-worksubs-02'

az vm delete --name 'myVM' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02' --yes --nic-delete-options 'delete' --os-disk-delete-options 'delete'

#az network nic delete --name 'myNic' --resource-group 'Bicep-fundermental-resourcegroup' --subscription 'skaneshiro-worksubs-02'