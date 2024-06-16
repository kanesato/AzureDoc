
# **■AFWログ クエリ集**
## +Azure Firewall Application Rule Log

```Kusto
AzureDiagnostics 
|where OperationName =="AzureFirewallApplicationRuleLog"
| parse msg_s with  *"request from" From "to" To ". Action:" Action
|project  TimeGenerated,OperationName,From,To,Action
```


## +Azure Firewall Network Rule Log

```Kusto
AzureDiagnostics
| parse msg_s with Protocol " request from " SourceIP ":" SourcePortInt:int " to " TargetIP ":" TargetPortInt:int *
| parse kind=regex flags=U msg_s with * ". Action: " Action1a "."
| parse msg_s with * " was " Action1b:string " to " TranslatedDestination:string ":" TranslatedPort:int *
| parse msg_s with * ". Policy: " Policy ". Rule Collection Group: " RuleCollectionGroup "." *
| parse msg_s with * " Rule Collection: "  RuleCollection ". Rule: " Rule
| parse msg_s with Protocol2 " request from " SourceIP2 " to " TargetIP2 ". Action: " Action2
| extend
SourcePort = tostring(SourcePortInt),
TargetPort = tostring(TargetPortInt)
| extend
    Action = case(Action1a == "", case(Action1b == "",Action2,Action1b), split(Action1a,".")[0]),
    Protocol = case(Protocol == "", Protocol2, Protocol),
    SourceIP = case(SourceIP == "", SourceIP2, SourceIP),
    TargetIP = case(TargetIP == "", TargetIP2, TargetIP),
    SourcePort = case(SourcePort == "", "N/A", SourcePort),
    TargetPort = case(TargetPort == "", "N/A", TargetPort),
    TranslatedDestination = case(TranslatedDestination == "", "N/A", TranslatedDestination), 
    TranslatedPort = case(isnull(TranslatedPort), "N/A", tostring(TranslatedPort)),
    Policy = case(Policy == "", "N/A", Policy),
    RuleCollectionGroup = case(RuleCollectionGroup == "", "N/A", RuleCollectionGroup ),
    RuleCollection = case(RuleCollection == "", "N/A", RuleCollection ),
    Rule = case(Rule == "", "N/A", Rule)
| where OperationName == "AzureFirewallNetworkRuleLog"
| where SourceIP == "172.17.254.4"
| where TargetIP == "172.17.250.7"
| where Action contains "Deny"
| top 2 by TimeGenerated desc
| project TimeGenerated, SourceIP,SourcePort, TargetIP, TargetPort, Protocol, Action, Rule
```

```Kusto
AzureDiagnostics
| where SourceIP == "192.168.0.0"
| top 1000 by TimeGenerated desc
| project TimeGenerated, SourceIP,SourcePort_d, DestinationIp_s, DestinationPort_d, Protocol_s, Action_s
```

---

## +Azure Firewall IDS Log

```Kusto
AzureDiagnostics
| where OperationName == "AzureFirewallIDSLog"
| parse msg_s with  *"request from" From "to" To ". Action:" Action ". Signature:" AlertSignature ". IDS:" IDS ". Priority:" Priority ". Classification:" Classification
|project  TimeGenerated,OperationName,From,To,Action,AlertSignature,IDS,Priority,Classification
```

## +Azure Firewall NAT Rule log

```Kusto
AzureDiagnostics
| where OperationName == "AzureFirewallNatRuleLog"
| parse msg_s with  *"request from" From "to" To "was DNAT'ed to" DNATto ". Policy:" Policy ". Rule:"Rule
|project  TimeGenerated,OperationName,From,To,DNATto,Policy
```

<br>

---

# **■Bastion Audit log**

```Kusto
// All Syslog 
// Last 100 Syslog. 
MicrosoftAzureBastionAuditLogs 
| top 100 by TimeGenerated desc
| project Time, ClientIpAddress, ClientPort, TargetVMIPAddress, Message
```
# **■Storage Account Log**
```Kusto
StorageBlobLogs 
| top 100 by TimeGenerated desc
| project AccountName, OperationName, CallerIpAddress, ObjectKey, Category
```

```Kusto
StorageBlobLogs 
| top 100 by TimeGenerated desc
| where CallerIpAddress like "126.216.169.85"
| project TimeGenerated, AccountName, OperationName, CallerIpAddress, ObjectKey, Category
```

```Kusto
StorageBlobLogs 
| top 100 by TimeGenerated desc
| where Category like "Delete"
| project AccountName, OperationName, CallerIpAddress, ObjectKey, Category
```

# **■ Application Gateway Log**
```Kusto
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess"
| where clientIP_s == "172.17.254.4"
| where host_s == "172.17.250.7"
| where clientPort_d == 443
| where httpStatus_d == 404
| top 100 by TimeGenerated desc
| project TimeGenerated, clientIP_s, host_s, originalHost_s, clientPort_d, httpStatus_d, listenerName_s, backendPoolName_s, backendSettingName_s, originalRequestUriWithArgs_s
```

### **List**
||||
|---|---|---|
|#|Articles|remarks|
|1|[Azure Firewall のログ(Azure Diagnostics)を Log Analytics で見やすくする](https://qiita.com/aktsmm/items/380eab220bd892581a19)||
|2|[Bastion Audit log](https://learn.microsoft.com/ja-jp/azure/azure-monitor/reference/tables/MicrosoftAzureBastionAuditLogs)||
||||
