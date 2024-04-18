[Back to the demo's homepage](../../IoTDigitalTwinDemo.md#event-grid)

### Create an Event Grid subscription to transport telemetry data from a specific IoT Hub to a specific Digital Twins
```bash
az eventgrid event-subscription create --name <name-for-hub-event-subscription> --event-delivery-schema eventgridschema --source-resource-id /subscriptions/<your-subscription-ID>/resourceGroups/<your-resource-group>/providers/Microsoft.Devices/IotHubs/<your-IoT-hub> --included-event-types Microsoft.Devices.DeviceTelemetry --endpoint-type azurefunction --endpoint /subscriptions/<your-subscription-ID>/resourceGroups/<your-resource-group>/providers/Microsoft.Web/sites/<your-function-app>/functions/ProcessHubToDTEvents
```

e.g.
```bash
az eventgrid event-subscription create --name "poc-eventgrid-trigger" --event-delivery-schema eventgridschema --source-resource-id /subscriptions/xxxxx-xxxxxx-xxxxxx-xxxxx-xxxxxxx/resourceGroups/poc-iot-digital-twin/providers/Microsoft.Devices/IotHubs/poc-iothub-kaneshiro --included-event-types Microsoft.Devices.DeviceTelemetry --endpoint-type azurefunction --endpoint /subscriptions/xxxxx-xxxxxx-xxxxxx-xxxxx-xxxxxxx/resourceGroups/poc-iot-digital-twin/providers/Microsoft.Web/sites/poc-iothub-to-dt-trial/functions/ProcessHubToDTEvents
```