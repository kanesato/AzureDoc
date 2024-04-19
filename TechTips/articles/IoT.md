> ### Step of [Connecting a Raspberry Pi to Azure IoT Hub]
1. Set up your Azure IoT Hub:<br>
Log in to the Azure portal (https://portal.azure.com) and create a new IoT Hub resource.<br>
Configure the desired settings such as pricing tier, resource group, and region.

2. Register your device:<br>
In the Azure portal, navigate to your IoT Hub resource.
Under "Explorers," select "IoT devices" and click on "New."<br>
Provide a unique device ID and optionally configure other settings.<br>
Click on "Save" to register the device.<br>

3. Prepare your Raspberry Pi:<br>
- Ensure that your Raspberry Pi is set up and connected to the internet.<br>
- Ensure I2C is enabled on your Raspberry Pi.<br>
- Install the necessary software components:
Install the Azure IoT SDK by following the official Azure IoT C SDK installation guide: https://github.com/Azure/azure-iot-sdk-c/blob/master/doc/devbox_setup.md <br>
※ Alternatively, you can use the Python SDK or any other supported programming language.<br>

4. Write the code to connect to Azure IoT Hub:<br>
Write the code that will run on your Raspberry Pi to connect to Azure IoT Hub using the SDK of your choice.<br>
The code will typically involve establishing a connection, authenticating with the device credentials, and sending telemetry data or receiving commands.

5. Run the code on your Raspberry Pi:<br>
Transfer the code to your Raspberry Pi.<br>
Compile and run the code on the Raspberry Pi.<br>
Ensure that the Raspberry Pi is connected to the internet.<br>

6. Monitor the device in Azure IoT Hub:<br>
Go back to the Azure portal and navigate to your IoT Hub resource.<br>
Under "Explorers," select "IoT devices" to view the registered devices.<br>
Select your device to monitor telemetry, send commands, or perform other operations.

<br>




