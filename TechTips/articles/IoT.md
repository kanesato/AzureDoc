## Raspberry PI IoTHub

> ### **Reference Links**<br>

- 【Raspberry Pi】温湿度センサー（BME280）を動かす方法 / How to connect a BME280 sensor to a Raspberry Pi<br>
(https://www.radical-dreamer.com/programming/raspberry-pi-bcm280/) <br>

- Raspberry Pi: BME280 Temperature, Humidity and Pressure Sensor (Python)<br>
(https://randomnerdtutorials.com/raspberry-pi-bme280-python/)<br>

- Raspberry Pi(Python)からAzure IoT Hubへテレメトリーを送信する<br>
(https://qiita.com/motoJinC25/items/69545d1cba22793ccf95)<br>

- ★Azure IoT HubにRaspberry Piで収集した温度データを送ってみた<br>
(https://www.tama-negi.com/2020/11/11/azure-iot-raspberry4/)<br>

- Azure-iot-sdk-python<br>
(https://github.com/Azure/azure-iot-sdk-python)<br>

- Azureに入門！ラズパイとPythonから接続してみた！<br>
※ Having the method to receive messages from Azure IoT Hub<br>
(https://misoji-engineer.com/archives/azure-raspberry-pi.html#toc11)

---

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

> ### Introduce a Raspberry Pi to Azure IoT Hub environment (Python)
Needs Python(3), Azure IoT SDK, and Raspberry Pi

- Confirm BME280 sensor's I2C address
```bash
sudo i2cdetect -y 1
```
- Install Python on Raspberry Pi
```bash
sudo apt-get install python3
```
- Update pip and setuptools
```bash
sudo pip install --upgrade pip
```
- Install the BME280 library
```bash
sudo pip install RPI.BME280
```
- Install pytz library (includes timestamp)
```bash
pip install pytz
```
- Run the Phthon file
( ../IoTRef/RaspberryPi/iothub-device.py )



