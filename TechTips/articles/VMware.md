## To install a driver on ESXi(vib or tag.gz)
1. Upload the driver files to the storage in ESXi
2. SSH to ESXi
3. Run the command below<br>
   esxcli software vib install -d　/vmfs/volumes/datastore1/DriverName.vib

## ★ Install Realtek8125 driver on ESXs 7.0 or later
1. Download the driver from [here](./files/Net-Community-Driver_1.2.7.0-1vmw.700.1.0.15843807_19480755.zip)<br>
2. Upload the driver files to the storage in ESXi
3. Login to ESXi via SSH
4. Copy Zip file to /var/log/vmware
5. Run the command below<br>
   esxcli software vib install -d Net-Community-Driver_1.2.7.0-1vmw.700.1.0.15843807_19480755.zip <br>
<font color="Red">Attention: If a [DependencyError] was reported, add "-f" before "-d" to force installation.</font>

## ESXiサービスコンソールからNIC リンクステータスを確認する
esxcli network nic list<br>
or<br>
esxcfg-nics -l<br>

## ESXiに認識されていないNICのリストを表示する
lspci -v | grep -A1 -i ethernet

