-- main_switch.lua Main code for mqtt connections and set mode of Node
-- Authors _ Daniela Beckmann Giulian Frisoni 
-- Pin mode for SENSOR node is INPUT
-- You can select whatever pin you need, reference nodeMCU GPIO
      gpio.mode(4, gpio.OUTPUT,gpio.PULLUP)
      gpio.write(4,gpio.LOW)  
-- Start MQTT conection to server
-- We create a client named node because client is already defined by API
-- MQTT credentials are loaded and modified on credentials file

  node = mqtt.Client(mqtt_idclient, 120)
  -- Set up LAST WILL and Testament if  WANTED
  node:lwt("/lwt", "offline", 0, 0)
-- Connect node object to Broker  
  node:connect( mqtt_ip , mqtt_port, 0,
  function(conn)
    print("Connected to MQTT:" .. mqtt_ip .. ":" .. mqtt_port .." as " .. mqtt_idclient )
   
    node:subscribe(mqtt_topic,0, function(conn) 
    -- SET tmr to go update light status every given ms 
    -- Note that bigger ms the lower energy drained
         
  end)
  
    end,
    function(client, reason)
      -- Second callback in case of connection failure
  print("Connection failed: " .. reason)
  
end)    

-- On OFFLINE STATUS 
node:on("offline", function(con)
-- Do an action in case of offline statement
print ("Node is OFFLINE RETRY") 
end)

-- On message callback given a topic, and data specified.
-- In this case relay is triggered by LOW logic
--     gpio.LOW = ON      gpio.HIGH = OFF                 
node:on("message", function(conn, topic, data)

  print(topic .. ":" )
  if data ~= nil then

    print(data)
  end
  if (data == "0" and topic == mqtt_topic ) then
gpio.write(4, gpio.HIGH)
print("Switch OFF")
  end
  if (data == "1" and topic == mqtt_topic ) then
gpio.write(4, gpio.LOW)
print("Switch ON")
  end 
end)
  

