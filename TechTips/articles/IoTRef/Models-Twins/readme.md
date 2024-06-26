
[Back to the demo's homepage](../../IoTDigitalTwinDemo.md#azure-digital-twins)

> ### Reference links
- 【Azure Digital Twins】IoTデバイスの状態を可視化する（前編）<br>
(https://blog.jbs.co.jp/entry/2023/09/26/170454)<br>

- 【Azure Digital Twins】IoTデバイスの状態を可視化する（後編）<br>
(https://blog.jbs.co.jp/entry/2023/09/27/115355)<br>


- ### Create two models on a specific Digital Twins instance 
```bash
az dt model create -n "adt-demo.api.jpe.digitaltwins.azure.net" --models /Volumes/ExtraDisk/Github/AzureDoc/TechTips/articles/IoTRef/Models-Twins/Room.json
```

```bash
az dt model create -n "adt-demo.api.jpe.digitaltwins.azure.net" --models /Volumes/ExtraDisk/Github/AzureDoc/TechTips/articles/IoTRef/Models-Twins/Thermostat.json
```

- ### Create two twins on a specific Digital Twins instance
```bash
az dt twin create -n "adt-demo.api.jpe.digitaltwins.azure.net" --dtmi "dtmi:sample:room;2" --twin-id room
```

```bash
az dt twin create -n "adt-demo.api.jpe.digitaltwins.azure.net" --dtmi "dtmi:sample:DigitalTwins:thermostat;1" --twin-id thermostat
```

- ### Update a relationship between two twins on a specific Digital Twins instance
```bash
az dt twin relationship create -n "adt-demo.api.jpe.digitaltwins.azure.net" --relationship-id room --relationship contains --twin-id room --target thermostat
```


<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

- ### Create an Event Grid subscription to trigger the function
```bash
az eventgrid event-subscription create --name "poc-eventgrid-trigger" --event-delivery-schema eventgridschema --source-resource-id /subscriptions/d8df623a-79c2-47ca-8542-9fdc6d9942e2/resourceGroups/poc-iot-digital-twin/providers/Microsoft.Devices/IotHubs/poc-iothub-kaneshiro --included-event-types Microsoft.Devices.DeviceTelemetry --endpoint-type azurefunction --endpoint /subscriptions/d8df623a-79c2-47ca-8542-9fdc6d9942e2/resourceGroups/poc-iot-digital-twin/providers/Microsoft.Web/sites/poc-iothub-to-dt-trial/functions/ProcessHubToDTEvents
```
