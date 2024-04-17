## ■Tips
- ASG

- [Network ipconfig](https://learn.microsoft.com/ja-jp/cli/azure/network/nic/ip-config?view=azure-cli-latest#az-network-nic-ip-config-update)
    - `az network nic ip-config show -g <resource group name> --nic-name <nic name> --query "[].{name:name, privateIp:privateIpAddress, publicIp:publicIpAddress.id}" -o table`
      - Example： az network nic ip-config show --resource-group self-s2s-spokevnet01-resourcegroup --name ipconfig1 --nic-name self-spoke01-windows-02-vm433

    - `az network nic ip-config update -g <resource group name> --nic-name <nic name> --query "[].{name:name, privateIp:privateIpAddress, publicIp:publicIpAddress.id}" -o table`
      - Example(add asg)： az network nic ip-config update --resource-group self-s2s-spokevnet01-resourcegroup --name ipconfig1 --nic-name self-spoke01-windows-02-vm433 --asg self-s2s-asg-01
      - Example(delete asg)： az network nic ip-config update --resource-group self-s2s-spokevnet01-resourcegroup --name ipconfig1 --nic-name self-spoke01-windows-02-vm433 --asg null


## ■Common Command

```powershell

### > login
az login --user "" --password ""

### > logout
az logout

### > resource-group
az group list --output table
az group list --tag environment=prod --output table

### > Azure Policy
az policy show --name <policy name> --query "[].{displayName:displayName, description:description, policyRule:policyRule}" -o table

# Azure Policy assignment
az policy assignment list --output table
#export the assignment list to a json file stored in c:¥user¥<username>¥
az policy assignment list --output json > policy_assignment_list.json

# Azure Policy Definition
az policy definition list --output table

az policy definition list --query "[].{displayname:displaynam, name:name, description:description,  policyRule:policyRule}" --output json > policy-definitions.json

```

- **components of definition**
  - "description"
  - "displayName"
  - "id"
  - "metadata"
  - "mode"
  - "name"
  - "parameters"
  - "policyRule"
  - "policyType"
  - "type"
<br>

- **components of assignment**
  - "description"
  - "displayName"
  - "enforcementMode"
  - "id"
  - "identity"
  - "location"
  - "metadata"
  - "name"
  - "nonComplianceMessages"
  - "notScopes"
  - "parameters"
  - "policyDefinitionId"
  - "policyDefinitionReferenceId"
  - "scope"
  - "systemData"
  - "type"





