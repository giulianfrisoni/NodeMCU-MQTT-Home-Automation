-- main_touch.lua Main code for mqtt connections and set mode of Node to pir sensor
-- Authors  Daniela Beckmann Giulian Frisoni 

-- Pin mode for SENSOR node is INTERRUPT trigger
-- You can select whatever pin you need, reference nodeMCU GPIO
-- Be careful using pins D0, D4, D3 and D5 as they interfere when LOW or HIGH on the correct startup from flash memory
   local pin=2

-- Set status of GPIO to input or trigger as needed
   gpio.mode(pin,gpio.INT)


-- Start MQTT conection to server
-- We create a client named node as client is already defined by API
-- MQTT credentials are loaded and defined on init file.

-- Connect to MQTT service and create a client  object
  node = mqtt.Client(mqtt_idclient, 120)
  -- In case of going offline send message
  node:on("offline", function(con) print ("offline")  end)
  -- Set up LAST WILL and Testament if  WANTED
  node:lwt("/lwt", "offline", 0, 0)
  -- Connect to broker
  node:connect( mqtt_ip , mqtt_port, 0,
        function(conn)
            print("Connected to MQTT:" .. mqtt_ip .. ":" .. mqtt_port .." as " .. mqtt_idclient )
 
              -- Uncomment  tmr to go to send function every given  ms or as needed once connection succeded
              
              -- tmr.stop(6)
              -- tmr.alarm(6, 6000, 1, send)
       
  end,
  -- Second callback in case of connection failure
  function(client, reason)
  print("Connection Failed: " .. reason) 
end)

 -- Function send() sents given logic of switch ON/OFF commands
 -- We use lasttouch variable so we make sure it changes the state of switch 
local lasttouch= nil
function send()
    if lasttouch == 0 then
        node:publish("home/prueba","1",0,0, function(conn) 
        print("sent 1") 
        -- PUT WHATEVER DATA YOU NEED HERE TO SEND    
        end)
      lasttouch=1
    else
      node:publish("home/prueba","0",0,0, function(conn) 
      print("sent 0") 
      -- PUT WHATEVER DATA YOU NEED HERE TO SEND
      lasttouch=0
      end)
      
      end
      end
-- SET trigger for specified pin on CONDITION "UP" and callback to send() function
gpio.trig(pin,"up", send)
      
