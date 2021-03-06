--init.lua  Authors: Giulian Frisoni
--          Main code that runs on bootloader
--          Used for starting Wifi connection and starting main file
--          Saved on flash memory inside NodeMcu
--         First file that is uploaded, should always be called init.lua
--          
--  credentials, 'SSID' and 'PASSWORD', MQTT server info used on both main files
-- credentials Variables used to modify network parameters
--                  without the need to edit code.
--  We recommend using and USER and PASSWORD for MQTT for security reasons

-- Wifi Credentials
-- wifi_SSID is STRING TYPE (="SSID")
-- wifi_PASSWORD can be string (wifi_PASSWORD="password") or int (wifi_PASSWORD=12345789)
wifi_SSID = "SSID HERE"
wifi_PASSWORD =PASSWORDHERE

-- MQTT Credentials
-- Uncomment mqtt_user and mqtt_pass if Mqtt server is secured
mqtt_idclient=node.chipid()-- Client id name for auth in MQTT server;
mqtt_keepalive=120
mqtt_ip="192.168.1.76"
mqtt_port=1883
mqtt_topic="home/prueba"
-- mqtt_user="USERNAME"
-- mqtt_pass="PASSWORD"


-- START WIFI CONNECTION
-- All print("") are serial info for performance delete or comment them
print("Starting configuring Wifi...")

-- Set Wifi as station and set credentials of local network 
wifi.setmode(wifi.STATION)
wifi.sta.config{ssid=wifi_SSID, pwd=wifi_PASSWORD} 

-- Once Wifi is configured define wifi variables to nil so in built garbage collector  cleans memory
wifi_SSID = nil
wifi_PASSWORD = nil

-- Connect to Wifi as Station
wifi.sta.connect()

-- Loop to wait for connection to be established
tmr.alarm(1, 1000, 1, function()
  if wifi.sta.getip() == nil then
    print("Waiting for IP...")
  else
    tmr.stop(1)
    print("Connection established, IP : " .. wifi.sta.getip())
    
    print("3 second hold up...")
    --Wait for 3 seconds and then run init function
    tmr.alarm(0, 3000, 0, init) 
  end
end)

function init()
  if file.open("init.lua") == nil then
    print("init.lua was erased or renamed")
  else
  
  print("Starting Main function file")
  -- Close init.lua so if a restart or power goes off the archive is not damaged  
    file.close("init.lua")
    
   -- IF Electric switch = main_switch
   -- IF Touch controller = main_touch
   -- IF wifi Temperature and Humid = main_temperature
   dofile("main_touch.lua")
  end
end
