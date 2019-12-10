# MQTT-Home-Automation
 Giulian Frisoni Lopez

Implementation of LUA and MQTT for easy replication of Home automation basic nodes ( Actuator and Sensor);

## Tools Used:
-Pyflasher for NodeMCU
https://github.com/marcelstoer/nodemcu-pyflasher

-ESPlorer for LUA scripting and Uploading to NodeMcu
https://esp8266.ru/esplorer/


## Material to be used:
- nodeMCU rev3 Board that can be shopped easily and is cheap.
- 3.3v/120AC Switch for controlling lights.
- 3.3V Person Sensor that can be shopped online easily.
- Wemos Uno R1 (Arduino Uno WIFI based)
- DHT temperature sensor.
- Raspberry Pi or PC running linux (There is also a Windows distribution of mosquitto,with same utility).

## Creating an MQTT broker using mosquitto and Ubuntu/Raspbian
### Things we Need:
> - Ubuntu 16.04+ or Raspberry Pi Running Raspbian.
> - Connection on device to local network.

### Installation
We will be working with the linux terminal to configuring and installing mosquitto
> 1. In terminal 
```
sudo apt install mosquitto'
```
> 2. Check if mosquitto is running just writing
```
mosquitto
```

>- NOTE: If you need to run mosquitto on Windows use this tutorial:
 https://sivatechworld.wordpress.com/2015/06/11/step-by-step-installing-and-configuring-mosquitto-with-windows-7/

### Configuring mosquitto
mosquitto is by default controlled by /etc/mosquitto/mosquitto.conf but it is a reccomendation to leave the defaults alone an create your own .conf file.
#### First lets create an user and password for it
 In terminal
 ```
sudo mosquitto_passwd -c /etc/mosquitto/passwd <user_name> 
```
 After that it will ask you to enter 2 times the password
 Note that we created the file passwd and when you enter a new entry it will be encryptated.So you can only manage users by mosquitto_passwd.
 
 #### mosquitto .conf file
 Open mosquitto.conf file to edit
 ` sudo gedit /etc/mosquitto/mosquitto.conf `
 
 So we created an user file for mosquitto to run, lets tell it to use it and at the same time we will stop anonymus log in in our server.
 Add the next two lines to mosquitto.conf
 ```
 password_file /etc/mosquitto/passwd
allow_anonymous false
 ```
There are other parameter we can change as listeners,ports,etc in this tutorial we are running mosquitto on an offline local network so more  security was not needed if you need to listen on other ports nad some others configuration like SSL and webpockets look at this page:

https://mosquitto.org/man/mosquitto-conf-5.html#

## Node Setup
***Install ch-341 driver in order to windows to recognize your NodeMCU***
*** DOWNLOAD FROM HERE http://www.wch.cn/downloads/file/5.html ***

### Flash your nodeMCU firmware first so it can work with lua and not AP commands:
- Get Firmware from the firmware folder in this repository or build one on 
   https://nodemcu-build.com/
- Use pyflasher to flash your nodeMCU get it from here:
  https://github.com/marcelstoer/nodemcu-pyflasher/releases
- Connect your nodeMCU via microusb to computer and in pyflasher browse to firmware.bin file and click on flash nodeMCU. WAIT TILL     FINISHED.


### PCB and electronics components for each nodeMCU module
- All electronic schemas are in this repository on the schemas folder.
#### Depending on what node you will use this components:
- For switch node, use: NodeMCU, relay and power supply.
- For touch node, use: NodeMCU, TTP223 and power supply.
- For temperature node, use: NodeMCU, DHT11/22 and power supply.

- For power suppy, you can use the VIN and GND pins connected to a 5V supply or use the micro USB connector on the NodeMCU.

### NodeMCU code upload and fields to change in code.
- You will need and lua and code compiler for nodeMCU i reccomend ESplorer, you can get it from here:
https://esp8266.ru/esplorer/
#### the init.lua file is mandatory for all modules as it initializes wifi connections and mqtt credentials, chamge the next fields:
-  Change code to match your setup.
-  wifi_SSID = "SSID HERE"
-  wifi_PASSWORD =PASSWORDHERE
-  mqtt_ip="192.168.1.76"
-  mqtt_port=1883
-  mqtt_topic="home/topic1"
-  dofile("main_touch.lua") - Put here what of the 3 main_*.lua you will use on that module.

#### for the main_*.lua files change on what pin you will be using the sensors, or relays.
- pin=<nummber of pin used>.
 
 #### Process
 - Get Esplorer.
 - Download code files.
 - Change variables for init.lua to match your setup of wifi and mqtt broker.
 - Select what module of the main_*.lua files you will use and change the pin number to match your nodeMCU setup.
 - Use "Send to ESP" button to test your code.
 - Once your code works use the "Save to ESP" button to save on the memory of esp your code.
 
