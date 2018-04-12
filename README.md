# MQTT-Home-Automation
Ana Daniela Beckmann Garcia and Giulian Frisoni Lopez

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


