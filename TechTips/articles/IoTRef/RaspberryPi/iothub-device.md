[Back to the demo's homepage](../../IoTDigitalTwinDemo.md#iot-device---raspberry-pi)

# Sample code (Python) for sending telemetry data from Raspberry Pi to an Azure IoT Hub

## - Install the necessary runtime and libraries on the Raspberry Pi.
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


## - Copy the code below and save it as a Python file (e.g., `iothub-device.py`) on a Raspberry Pi.


```python
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
import os
import random
import time
import smbus2
import bme280
import pytz
import json
import math
from azure.iot.device import IoTHubDeviceClient, Message

# The device connection authenticates your device to your IoT hub. The connection string for
# a device should never be stored in code. For the sake of simplicity we're using an environment
# variable here. If you created the environment variable with the IDE running, stop and restart
# the IDE to pick up the environment variable.
#
# You can use the Azure CLI to find the connection string:
# az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyNodeDevice --output table

# ------------------
# --- Defination ---
# ------------------
# CONNECTION_STRING = os.getenv("IOTHUB_DEVICE_CONNECTION_STRING")
# CONNECTION_STRING = ""
# Replace the value of CONNECTION_STRING with the primary connection string of the device you created in the Azure portal.
CONNECTION_STRING = < device connection_string >

# --- Definition of the BME280 sensor ---
# BME280 sensor address (default address)
address = 0x76
# Initialize I2C bus
bus = smbus2.SMBus(1)
# Load calibration parameters
calibration_params = bme280.load_calibration_params(bus, address)

# Define the JSON message to send to IoT Hub.
TEMPERATURE = 20.0
HUMIDITY = 60
# MSG_TXT = '{{"Temperature":{temperature},"humidity(H)": {humidity},"pressure(hPa)": {pressure},"timestamp": {timestamp}}}'
MSG_TXT = "{\"Temperature\": %f,\"Humidity\": %f,\"Pressure\": %f}"
# MSG_TXT = "{\"Temperature\": %f,\"humidity\": %f}"
# MSG_TXT = "{\"Temperature\":%f}"

def run_telemetry_sample(client):
    # This sample will send temperature telemetry every second
    print("IoT Hub device sending periodic messages")

    client.connect()
    client.on_message_received = message_received_handler

    while True:

        # ------------------
        # Read sensor data
        data = bme280.sample(bus, address, calibration_params)
        # Extract temperature, pressure, humidity, and corresponding timestamp
        temperature = data.temperature
        humidity = data.humidity
        pressure = data.pressure
        timestamp = data.timestamp
        # ------------------

        # ------------------
        # Adjust timezone
        # Define the timezone you want to use (list of timezones: https://gist.github.com/mjrulesamrat/0c1f7de951d3c508fb3a20b4b0b33a98)
        desired_timezone = pytz.timezone('Asia/Tokyo')  # Replace with your desired timezone
        # Convert the datetime to the desired timezone
        timestamp_tz = timestamp.replace(tzinfo=pytz.utc).astimezone(desired_timezone)
        # ------------------

        # Build the message with simulated telemetry values.
        # msg_txt_formatted = MSG_TXT.format(Temperature=round(temperature,2), Humidity=round(humidity,2), Pressure=round(pressure,1), Timestamp=timestamp_tz.strftime('%H:%M:%S %Y/%m/%d'))
        msg_txt_formatted = MSG_TXT % (float(temperature),float(humidity),float(pressure))
        # msg_txt_formatted = MSG_TXT % (round(temperature,2))

        message = Message(msg_txt_formatted)
        message.content_encoding = "utf-8"
        message.content_type = "application/json"

        # Add a custom application property to the message.
        # An IoT hub can filter on these properties without access to the message body.
        if temperature > 30:
            message.custom_properties["temperatureAlert"] = "true"
        else:
            message.custom_properties["temperatureAlert"] = "false"

        # message.custom_properties["Message"] = message

        # Send the message.
        print("Sending message: {}".format(message))
        client.send_message(message)
        print("Message successfully sent")
        time.sleep(3)

# define behavior for receiving a message
def message_received_handler(message):
    print("the data in the message received was ")
    print(message.data)
    #print("custom properties are")
    #print(message.custom_properties)

def main():
    print("IoT Hub Quickstart #1 - Raspberry Pi 4")
    print("Press Ctrl-C to exit")

    # Instantiate the client. Use the same instance of the client for the duration of
    # your application
    client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)

    # Run Sample
    try:
        run_telemetry_sample(client)
    except KeyboardInterrupt:
        print("IoTHubClient sample stopped by user")
    finally:
        # Upon application exit, shut down the client
        print("Shutting down IoTHubClient")
        client.shutdown()

if __name__ == '__main__':
    main()
```
