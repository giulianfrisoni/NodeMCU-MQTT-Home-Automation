-- main_temperature.lua Main code for mqtt connections and set mode of Node
-- Authors  Daniela Beckmann Giulian Frisoni 
-- You can select whatever pin you need, reference nodeMCU GPIO
 -- Pin mode for SENSOR node is INPUT type
-- You can select whatever pin you need, reference nodeMCU GPIO
-- Be careful using pins D0, D4, D3 and D5 as they interfere when LOW or HIGH on normal boot
   local pin=2

-- Set status of GPIO to input or trigger as needed
   gpio.mode(pin,gpio.INPUT)


-- Start MQTT conection to server
-- We create a client named node as client is already defined by API
-- MQTT credentials are loaded and defined on init file.

-- Connect to MQTT service and create a client  object
  node = mqtt.Client(mqtt_idclient, 120)

  -- Set up LAST WILL and Testament if  WANTED
  node:lwt("/lwt", "offline", 0, 0)
  -- Connect to broker
  node:connect( mqtt_ip , mqtt_port, 0,
        function(conn)
            print("Connected to MQTT:" .. mqtt_ip .. ":" .. mqtt_port .." as " .. mqtt_idclient )
              -- Send temp and humid every given ms (5 min=30000)
              tmr.alarm(6, 30000, 1, send)
       
        end,
        -- Second callback in case of connection failure
        function(client, reason)
        print("Connection Failed: " .. reason) 
        end)

-- In case of going offline send message
node:on("offline", function(con) 
  -- Action WHEN OFFLINE  
end)


 -- Function send() sents given logic of switch ON/OFF commands
 -- We use lasttouch variable so we make sure it changes the state of switch 
function send()
   -- BASED on DHT sensors,  C° Degrees and Humidity Percentage   
    check, temperature, humidity, temp_dec, humi_dec = dht.read(pin)
    if check == dht.OK then
    -- Publish temperature and humidity
        node:publish("home/temp",temperature,0,0, function(conn) end)
        node:publish("home/humid",humidity,0,0, function(conn) end)
        print(temperature.." C and "..humidity.." % of humidity")
      -- Error can be published or commented out
    elseif check == dht.ERROR_CHECKSUM then
     node:publish("home/temp","Error",0,0, function(conn) end)       
    elseif check == dht.ERROR_TIMEOUT then
     node:publish("home/temp","Error",0,0, function(conn) end)    
    end      
    -- Save memory and nil  variables when function ends
     check, temperature, humidity, temp_dec, humi_dec = nil      
      end
      
     

