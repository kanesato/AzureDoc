> # Transport temperature data from a Raspberry Pi to a Digital Twins via an  IoT Hub

# ■Steps

## < IoT Device - Raspberry Pi >

1. ### Connect a BME280 sensor to a Raspberry Pi<br>

    - [reference]:【Raspberry Pi】温湿度センサー（BME280）を動かす方法 / How to connect a BME280 sensor to a Raspberry Pi<br>
(https://www.radical-dreamer.com/programming/raspberry-pi-bcm280/)<br>

    - The sample code(Python) for sending telemetry data from Raspberry Pi to an Azure IoT Hub<br>
[link](./IoTRef/RaspberryPi/iothub-device.md)

----------------------------------------------------------------------------------------------------------------------------
## < IoT Hub >

2. ### Create an IoT Hub and a device in Azure<br>
    - [reference]:Create an IoT hub using the Azure portal<br>
(https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-create-through-portal)

3. ### Register a device in the IoT Hub<br>
    - Register a new device (the primary connect string is needed in the python script)<br>

4. ### Deploy a message routing query in an IoT Hub <br>
    - [reference]:Create and delete routes and endpoints by using the Azure portal<br>
(https://learn.microsoft.com/en-us/azure/iot-hub/how-to-routing-portal?tabs=cosmosdb)

----------------------------------------------------------------------------------------------------------------------------
## < Azure Digital Twins >

5. ### Create a Digital Twins instance<br>
    - [reference]:Quickstart - Get started with a sample scenario in Azure Digital Twins Explorer<br>
(https://learn.microsoft.com/en-us/azure/digital-twins/quickstart-azure-digital-twins-explorer#prerequisites)

6. ### Deploy two Digital Twins models and twins<br>
    - [reference]:Digital Twins Definition Language (DTDL)<br>
(https://github.com/Azure/opendigitaltwins-dtdl/blob/master/DTDL/v2/DTDL.v2.md)
 
    - [reference]:Manage Azure Digital Twins models<br>
(https://learn.microsoft.com/en-us/azure/digital-twins/how-to-manage-model)

    - Sample models and twins<br>
    [link](./IoTRef/Models-Twins/readme.md)

----------------------------------------------------------------------------------------------------------------------------
## < Azure Functions >

7. ### Create an Azure Function (.NET) for transporting telemetry data from an IoT Hub to Digital Twins<br>
    - [reference]:Create your first function in the Azure portal<br>
(https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal?pivots=programming-language-csharp)

8. ### Deploy(Upload) the function to Azure Function<br>
    - [reference]:Deploy a function app in Azure using Visual Studio Code<br>
(https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)

    - Upload the applications below onto an Azure Functions by following the steps in the link below<br>
    [link](./IoTRef/publiczip-to-Functions/introduction.md)

9. ### Configure the function<br>
    - Add a variable named `ADT_SERVICE_URL` to the function app's [application configuration] settings, and set the Digital Twin's URL with "http://" as the value<br>

    - Turn on the "System assigned" to give the function app a Managed ID<br>

    - Assign "Azure Digital Twins Data Owner" to the function app's Managed ID on the Digital Twins panel<br>


----------------------------------------------------------------------------------------------------------------------------
## < Event Grid >

10. ### Deploy an Event Grid subscription to trigger the function<br>
    - [reference]:How to work with Event Grid triggers and bindings in Azure Functions<br>
(https://learn.microsoft.com/en-us/azure/azure-functions/event-grid-how-tos?tabs=v2%2Cportal)

    - Run the command below on the Azure CLI to create the Event Grid subscription<br>
    [link](./IoTRef/EventGridTrigger/readme.md)

----------------------------------------------------------------------------------------------------------------------------
## < Tips >
- The device name must be the same(includes uppercase and lowercase) as the twin's name which you want to synchronize the telemetry data with<br>
- After defining the twin with the property that you want to synchronize with, give the property a value like the number 1 for initialization<br>
- The telemetry data from the device must include the property "temperature" in the JSON format<br>
- Click [run query] on the Azure Digital Twins Explorer to refresh the telemetry data<br>

<br>
<br>
<br>
<br>
<br>
<br>

# ■Other reference links

- Azure Digital Twins Explorer と 3D Scenes Studio を試してみる<br>
(https://qiita.com/Futo_Horio/items/8f4f58b1c26753e2b7d5)
 

- Azure Digital Twins getting started samples<br>
(https://github.com/Azure-Samples/azure-digital-twins-getting-started/tree/main)


- Learn about twin models and how to define them in Azure Digital Twins<br>
(https://learn.microsoft.com/en-us/azure/digital-twins/concepts-models#model-overview)
