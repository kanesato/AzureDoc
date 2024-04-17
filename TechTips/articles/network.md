## **Tips**

ネットワークのトラブルシューティングは「DNS」, 「Firewall」 (通信制御機器), 「ルーティング」の三つに尽きる<br>
※DNSは名前解決<br>
※Firewallを始めるルート上の通信機器の設定<br>
※ルーティングはUDR、BGP広報<br>

---

Azure Firewallはステートフルで非対称通信を拒否する動作を取る<br>
※非対称通信とは、送信元と送信先のIPアドレスが異なる通信のこと

---

pingはICMPを使用するが、icmp echo (行き), icmp retruen (戻り) でけで実現するのでAFW からすると拒否しようがない<br>

---

**TCP/IP**の接続の確立 **（3-way handshake）**:<br>
通信を開始する前に、クライアントとサーバー間で接続を確立します。このために、3-way handshakeと呼ばれる手順が行われます。<br>
・クライアントがサーバーに対して接続要求 **（SYNパケット）** を送信します。<br>
・サーバーがクライアントに対して接続要求を受け入れる **（SYN-ACKパケット）** か否かを返信します。<br>
・クライアントがサーバーに対して確認応答 **（ACKパケット）** を送信し、接続が確立されます。<br>

---

Q：現状利用しているAzureのAPI（例：Read APIなど）のセキュリティをチェックするような方法<br>
A：Azure Policy 使ってパブリック通信を全部閉じる。という方針です
API って広すぎる気がします…<br>何を保護したいのかをちゃんとヒアリングしたほうが良いですね。何をやればいいかわからないけど、とりあえず外部公開を検知したいとかなら。<br><br>
[Azure Policyの概要](https://learn.microsoft.com/ja-jp/azure/governance/policy/overview)<br>
[組み込みのポリシー イニシアチブの一覧](https://learn.microsoft.com/ja-jp/azure/governance/policy/samples/built-in-initiatives#sdn)
<br><br>↓PaaS は一通り網羅してくれるはず。
|名前|説明|ポリシー|Version|
|:--|:--|:--|:--|
|[パブリック ネットワーク アクセスの監査](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/SDN/AuditPublicNetworkAccessInitiative.json)|パブリック インターネットからのアクセスを許可する Azure リソースを監査する|36|4.0.0|
|[サポートされているすべての Azure リソースで Private Link の使用状況を評価する]()|準拠しているリソースには、承認されたプライベート エンドポイント接続が少なくとも 1 つ必要です|30|1.0.0|
|[Microsoft クラウド セキュリティ ベンチマークの概要](https://learn.microsoft.com/ja-jp/security/benchmark/azure/overview)|その他の項目は？とか言われたら、この辺をくまなくチェックしてく感じかなと思います。|-|-| 
 
---

Express Route and Express VPN Gateway Metrics 
[ER Metrics](https://learn.microsoft.com/ja-jp/azure/expressroute/expressroute-monitoring-metrics-alerts#expressroute-circuit)
[ER VPNGW Metrics](https://learn.microsoft.com/ja-jp/azure/vpn-gateway/monitor-vpn-gateway-reference#metrics)