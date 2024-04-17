# ポリシー適用除外 : よくある適用除外 (Exemption - Waiver)

ポリシーにより環境をチェックした結果として、非準拠（または異常）が見つかった場合には、是正処理（修正作業）を実施するか、適用を除外する必要があります。

まず、論理的に問題が起こりえない状況と考えられるために、**当該ルールを適用する必要がない**、と判断される項目について、適用除外処理 (Exemption - Waiver) を行います。

## （参考・注意）用語について

Azure Policy と MDfC で、利用している用語が異なるため、以下に整理します。

![picture 1](./images/9a0e2470de37f89da1f0e0dccb6de7af119d8a926ddfbc084273a52404469c00.png)  

特に注意すべき点は、ポリシーの適用を除外（Exemption）する場合の理由付けです。ポリシーの適用除外（Exemption）は、以下の 2 つに分類されます。

- Waiver (軽減済み)
  - 他の方法によりルールが実質的に充足されている、あるいは論理的に問題が起こりえない状況であるために、**当該ルールを適用する必要がない**、と判断される場合です。
- Mitigated (免除)
  - **ルールは充足されていない**が、それによって生じるリスクを許容する、という場合です。よくあるケースは、本当はやった方が適切だが、PoC であるためにコストがかけられないのでやらないと判断するような場合です。

Exemption, Waiver, Mitigated には、それぞれ適用除外、軽減済み、免除という訳語が割り当てられていますが、これらの訳語は直感と必ずしもそぐわないところがあります。（例：「軽減済み」は、リスクは残っているけれども軽減されているので OK とみなす＝Mitigated に相当するような意味に解釈したり、「免除」を Exemption の意味で解釈してしまうような誤解が生じやすいです）

いずれの訳語を利用しても、人によって解釈がぶれやすく、誤解も生じやすいため、**敢えて英語表記のまま利用する** (Exemption, Waiver, Mitigated の用語を使う) のも一手です。本デモでは、Waiver, Mitigated の用語を積極的に利用しています。

```bash

# 業務システム統制チーム／③ 構成変更の作業アカウントに切り替え
if ${FLAG_USE_SOD} ; then az account clear ; az login -u "user_gov_change@${PRIMARY_DOMAIN_NAME}" -p "${ADMIN_PASSWORD}" ; fi
 
# ■ 以下は全体に共通
TEMP_MG_TRG_ID=$(az account management-group list --query "[?displayName=='Tenant Root Group'].id" -o tsv)
TEMP_ASSIGNMENT_ID=$(az policy assignment list --scope $TEMP_MG_TRG_ID --query "[? displayName == 'Azure Security Benchmark'].id" -o tsv)
 
# ■ フローログ保存用のストレージに対するネットワークセキュリティ確保の適用免除
# 内部利用のため、プライベートエンドポイントの作成は不要
# Storage accounts should use private link
# /providers/Microsoft.Authorization/policyDefinitions/6edd7eda-6dd8-40f7-810d-67160c639cd9
# storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect
 
TEMP_EXEMPTION_NAME="Exemption-FlowLogStorage"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "フローログ用のストレージであるため適用を免除",
    "description": "フローログ用のストレージであるためプライベートエンドポイントの作成は不要"
  }
}
EOF
 
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
  TEMP_RG_NAME="rg-vdc-${TEMP_LOCATION_PREFIX}"
  TEMP_FLOWLOG_STORAGE_NAME="stvdcfl${TEMP_LOCATION_PREFIX}${UNIQUE_SUFFIX}"
 
TEMP_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID_MGMT}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.storage/storageaccounts/${TEMP_FLOWLOG_STORAGE_NAME}"
 
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ ADE 用の KeyVault に対するネットワークセキュリティ確保の適用免除
# 内部利用のため、プライベートエンドポイントの作成は不要
# Azure Key Vaults should use private link
# /providers/Microsoft.Authorization/policyDefinitions/a6abeaec-4d90-4a02-805f-6b26c4d3fbe9
# privateEndpointShouldBeConfiguredForKeyVaultMonitoringEffect
 
#TEMP_RESOURCE_IDS[1]="/subscriptions/4104fe87-a508-4913-813c-0a23748cd402/resourcegroups/rg-test/providers/microsoft.keyvault/vaults/kv-test-spokea"
#TEMP_RESOURCE_IDS[2]="/subscriptions/903c6183-3adc-4577-9114-b3fef417ff28/resourcegroups/rg-ops-eus/providers/microsoft.keyvault/vaults/kv-ops-ade-20299-eus"
 
TEMP_EXEMPTION_NAME="Exemption-ADEKeyVault"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "privateEndpointShouldBeConfiguredForKeyVaultMonitoringEffect"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "ADE 用の KeyVault であるため適用を免除",
    "description": "ADE 用の KeyVault であるためプライベートエンドポイントの作成は不要"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
  TEMP_RG_NAME="rg-spokea-${TEMP_LOCATION_PREFIX}"
  TEMP_ADE_KV_NAME="kv-spokea-ade-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_A}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.keyvault/vaults/${TEMP_ADE_KV_NAME}"
j=`expr $j + 1`
 
  TEMP_RG_NAME="rg-ops-${TEMP_LOCATION_PREFIX}"
TEMP_ADE_KV_NAME="kv-ops-ade-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_MGMT}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.keyvault/vaults/${TEMP_ADE_KV_NAME}"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ 作成しているカスタムロールを Audit 対象から除外
# 既定ではカスタムロールの作成そのものが Audit 対象になっているため。Waiver を作成して承認済みであることを登録しておく
# ※ 下記スクリプトでは簡単のためにすべてのカスタムロールを一括で除外対象としたが、実際にはひとつずつ確認して除外すること
# ※ サブスクリプション単位の除外が必要 ⇒ Tenant Root Group レベルでカスタムロールを定義している場合、サブスクリプションが増えるつど設定が必要なため厄介。カスタムロールをフル活用する前提であれば、useRbacRulesMonitoringEffect を disabled にしてもよい。
# Audit usage of custom RBAC roles
# /providers/Microsoft.Authorization/policyDefinitions/a451c1ef-c6ca-483d-87ed-f49761e3ffb5
# useRbacRulesMonitoring
 
TEMP_EXEMPTION_NAME="Exemption-CustomRole"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "useRbacRulesMonitoring"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "承認されたカスタム RBAC ロール",
    "description": "承認されたカスタム RBAC ロール"
  }
}
EOF
 
for TEMP_SUBSCRIPTION_ID in ${SUBSCRIPTION_IDS}; do
az account set -s ${TEMP_SUBSCRIPTION_ID}
 
for TEMP_RESOURCE_ID in $(az role definition list --custom-role-only true --query [].id -o tsv); do
 
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
 
done # TEMP_RESOURCE_ID
done # TEMP_SUBSCRIPTION_ID
 
 
# ■ App Service のクライアント証明書を推奨するポリシーを除外
# App Service apps should have 'Client Certificates (Incoming client certificates)' enabled
#TEMP_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourcegroups/rg-spokeb-eus/providers/microsoft.web/sites/webapp-spokeb-eus"
 
TEMP_EXEMPTION_NAME="Exemption-AppServiceClientCertificates"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "ensureWEBAppHasClientCertificatesIncomingClientCertificatesSetToOnMonitoringEffect"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "AppServiceのクライアント証明書認証を免除",
    "description": "他の認証方式を利用しているためクライアント証明書を免除"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
TEMP_RG_NAME="rg-spokeb-${TEMP_LOCATION_PREFIX}"
TEMP_WEBAPP_NAME="webapp-spokeb-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
 
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.web/sites/${TEMP_WEBAPP_NAME}"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ エージェントの自動プロビジョニング機能の利用を免除する
# エージェントの自動配置は行わないため
# Auto provisioning of the Log Analytics agent should be enabled on your subscription
# /providers/Microsoft.Authorization/policyDefinitions/475aae12-b88a-4572-8b36-9b712b2b3a17
# autoProvisioningOfTheLogAnalyticsAgentShouldBeEnabledOnYourSubscriptionMonitoringEffect
 
TEMP_EXEMPTION_NAME="Exemption-MDfC-AgentAutoProvisioning"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "autoProvisioningOfTheLogAnalyticsAgentShouldBeEnabledOnYourSubscriptionMonitoringEffect"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "エージェントの自動プロビジョニング機能の利用を免除する",
    "description": "エージェントの自動配置は行わないため、エージェントの自動プロビジョニング機能の利用を免除する"
  }
}
EOF
 
for TEMP_RESOURCE_ID in $(az account subscription list --query [].id -o tsv); do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ Private Endpoint サブネットへの UDR 適用免除
# （カスタムポリシー用）
 
TEMP_EXEMPTION_NAME="Exemption-UDRonPrivateEndpointSubnet"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "/providers/Microsoft.Management/managementGroups/landingzones/providers/Microsoft.Authorization/policyAssignments/custom-check-lz",
    "policyDefinitionReferenceIds": [
      "custom-policy-check-network-subnet-with-udr"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "Private Endpoint サブネットへの UDR 適用免除",
    "description": "Private Endpoint サブネットからの outbound 通信は通常存在しないため。"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
TEMP_RG_NAME="rg-spokeb-${TEMP_LOCATION_PREFIX}"
TEMP_VNET_NAME="vnet-spokeb-${TEMP_LOCATION_PREFIX}"
 
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourcegroups/${TEMP_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${TEMP_VNET_NAME}"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
 
# ■ SQL DB へのアクセスに際しての Azure AD 認証の適用免除
# An Azure Active Directory administrator should be provisioned for SQL servers
# 1f314764-cb73-4fc9-b863-8eca98ac36e9
# aadAuthenticationInSqlServerMonitoring
# Azure SQL Database should have Azure Active Directory Only Authentication enabled
# abda6d70-9778-44e7-84a8-06713e6db027
# sqlServerADOnlyEnabledMonitoring
 
TEMP_EXEMPTION_NAME="Exemption-AzureADAuthenticationInSQLDatabase"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "aadAuthenticationInSqlServerMonitoring",
      "sqlServerADOnlyEnabledMonitoring"
    ],
    "exemptionCategory": "Mitigated",
    "displayName": "SQL DB へのアクセスに関する Azure AD 認証利用の免除",
    "description": "アプリケーション側での Azure AD 認証の適用が困難なため"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
TEMP_SQL_SERVER_NAME="sql-spokeb-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
TEMP_SQL_SERVER_NAME="sql-spokeb-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
TEMP_RG_NAME="rg-spokeb-${TEMP_LOCATION_PREFIX}"
 
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourceGroups/${TEMP_RG_NAME}/providers/Microsoft.Sql/servers/${TEMP_SQL_SERVER_NAME}"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ Application Gateway v2 に割り当てられている Subnet には NSG が付与できないため NSG を免除
# Subnets should be associated with a Network Security Group
# e71308d3-144b-4262-b144-efdc3cc90517
 
TEMP_EXEMPTION_NAME="Exemption-NSGonAppGatewaySubnet"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "networkSecurityGroupsOnSubnetsMonitoring"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "AppGateway が利用するサブネットへの NSG 適用の免除",
    "description": "AppGateway が利用するサブネットには NSG が適用できないため"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
TEMP_RG_NAME="rg-spokebdmz-${TEMP_LOCATION_PREFIX}"
TEMP_VNET_NAME="vnet-spokebdmz-${TEMP_LOCATION_PREFIX}"
 
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.network/virtualnetworks/${TEMP_VNET_NAME}/subnets/dmzsubnet"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ ポリシーがまだ preview であるため audit 対象から除外
# 例）[Preview]: Microsoft Defender for APIs should be enabled
# /providers/Microsoft.Authorization/policyDefinitions/7926a6d1-b268-4586-8197-e8ae90c877d7
enableDefenderForApis
 
TEMP_EXEMPTION_NAME="Exemption-PreviewPolicy-enableDefenderForApis"
TEMP_EXPIRATION_DATETIME=$(date -u -d "+6 month" "+%Y-%m-%dT%H:%M:%SZ")
 
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "enableDefenderForApis"
    ],
    "exemptionCategory": "Mitigated",
    "displayName": "現時点では Preview ポリシーのため適用を免除",
    "description": "現時点では Preview ポリシーのため適用を免除",
    "expiresOn": "${TEMP_EXPIRATION_DATETIME}"
  }
}
EOF
 
for TEMP_SUBSCRIPTION_ID in $(az account subscription list --query [].subscriptionId -o tsv); do
az account set -s ${TEMP_SUBSCRIPTION_ID}
 
TEMP_RESOURCE_ID="/subscriptions/${TEMP_SUBSCRIPTION_ID}"
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
 
done # TEMP_SUBSCRIPTION_ID
 
# ■ WAF の背後にある Web サーバへのアクセスでは HTTPS 通信を免除する
# App Service apps should only be accessible over HTTPS
# a4af4a39-4135-47fb-b175-47fbdf85311d
# webAppEnforceHttpsMonitoring
 
TEMP_EXEMPTION_NAME="Exemption-webAppEnforceHttpsMonitoring"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "webAppEnforceHttpsMonitoring"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "WAF の背後にある Web サーバであるため、HTTPS 適用を免除",
    "description": "WAF の背後にある Web サーバであるため、HTTPS 適用を免除"
  }
}
EOF
 
TEMP_RESOURCE_IDS=()
j=0
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
TEMP_RG_NAME="rg-spokeb-${TEMP_LOCATION_PREFIX}"
TEMP_WEBAPP_NAME="webapp-spokeb-${UNIQUE_SUFFIX}-${TEMP_LOCATION_PREFIX}"
 
TEMP_RESOURCE_IDS[j]="/subscriptions/${SUBSCRIPTION_ID_SPOKE_B}/resourcegroups/${TEMP_RG_NAME}/providers/microsoft.web/sites/${TEMP_WEBAPP_NAME}"
j=`expr $j + 1`
done
 
for TEMP_RESOURCE_ID in ${TEMP_RESOURCE_IDS[@]}; do
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
done
 
# ■ CSB の適用免除
# ミドルウェア（IIS, SQL Server など）による設定変更が CSB ルールに抵触するため除外
# Windows machines should meet requirements of the Azure compute security baseline
# /providers/Microsoft.Authorization/policyDefinitions/72650e9f-97bc-4b2a-ab5f-9781a9fcecbc
# windowsGuestConfigBaselinesMonitoring
 
TEMP_EXEMPTION_NAME="Exemption-FlowLogStorage"
cat > temp.json << EOF
{
  "properties": {
    "policyAssignmentId": "${TEMP_ASSIGNMENT_ID}",
    "policyDefinitionReferenceIds": [
      "windowsGuestConfigBaselinesMonitoring"
    ],
    "exemptionCategory": "Waiver",
    "displayName": "ミドルウェア (IIS, SQL) が CSB に抵触するため適用を免除",
    "description": "いったん CSB によるハードニングを行った上でミドルウェアをインストールしているため問題なし"
  }
}
EOF
 
for i in ${VDC_NUMBERS}; do
  TEMP_LOCATION_PREFIX=${LOCATION_PREFIXS[$i]}
 
TEMP_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID_SPOKE_A}/resourcegroups/rg-spokea-${TEMP_LOCATION_PREFIX}/providers/microsoft.compute/virtualmachines/vm-db-${TEMP_LOCATION_PREFIX}"
 
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
 
TEMP_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID_SPOKE_A}/resourcegroups/rg-spokea-${TEMP_LOCATION_PREFIX}/providers/microsoft.compute/virtualmachines/vm-web-${TEMP_LOCATION_PREFIX}"
 
az rest --method PUT --uri "${TEMP_RESOURCE_ID}/providers/Microsoft.Authorization/policyExemptions/${TEMP_EXEMPTION_NAME}?api-version=2022-07-01-preview" --body @temp.json
 
done

```
