# ポリシー作成 : Azure Security Benchmark の割り当て

Azure Security Benchmark を、ルート管理グループ 一か所のみに割り当てます。

```bash

if ${FLAG_USE_SOD} ; then az account clear ; az login -u "user_gov_change@${PRIMARY_DOMAIN_NAME}" -p "${ADMIN_PASSWORD}" ; fi
 
TEMP_MG_TRG_ID=$(az account management-group list --query "[?displayName=='Tenant Root Group'].id" -o tsv)
 
cat > temp.json << EOF
{
    "properties": {
        "displayName": "Azure Security Benchmark",
        "scope": "${TEMP_MG_TRG_ID}",
        "notScopes": [],
        "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8",
        "enforcementMode": "Default",
        "parameters": {},
        "nonComplianceMessages": [],
        "resourceSelectors": [],
        "overrides": []
    }
}
EOF
 
az rest --method PUT --uri "${TEMP_MG_TRG_ID}/providers/Microsoft.Authorization/policyAssignments/Azure Security Benchmark?api-version=2022-06-01" --body @temp.json
 
```

## （参考） ASB 適用に関する注意点

- ASB は比較的頻繁にバージョンアップされており、本スクリプトではその時点での最新版が適用されます。
  - このため、後の作業で実施する適用免除などについては過不足が生じる場合があり、適宜修正が必要になります。
  - 更新履歴は下記を参照してください。
    - https://www.azadvertizer.net/azpolicyinitiativesadvertizer/1f3afdf9-d0c9-4c3d-847f-89da613e70a8.html
- 現在、ASB (Azure Security Benchmark) は MCSB (Microsoft Cloud Security Benchmark) に名称変更されていますが、ポリシーファイルでは旧称が使われています。
  - このため本デモでは ASB という名称を利用しています。
- また、"Benchmark" と "Baseline" という用語については、ドキュメントなどでも一部混乱・御用が見受けられますが、あまり気にしなくて構いません。
  - 厳密には、以下のような意味の違いがあります。
    - Benchmark = 比較対象となるもの、守るべき基準となるもの
    - Baseline = 最低限、当たり前のこととしてちゃんと守るべきもの
  - 例えば...
    - ASB の正式名称は "Azure Security Benchmark"
    - CSB の正式名称は "Compute Security Baseline"
  - ですが、実際の使われ方としては「最低限守るべきもの、守るべき基準」として混同されている側面も多分にあるため、必要以上に拘らなくても実務上の問題はないと思います。~~わからない場合は略語表記にしてしまいましょう。~~
