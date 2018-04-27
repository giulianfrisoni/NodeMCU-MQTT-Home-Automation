-- main_switch.lua Main code for mqtt connections and set mode of Node
-- Authors _ Daniela Beckmann Giulian Frisoni 

    -- Pin mode for SENSOR node is INPUT
    -- You can select whatever pin you need, reference nodeMCU GPIO
    -- Define pin for RELAY INPUT
      pin=4
      gpio.mode(pin, gpio.OUTPUT,gpio.PULLUP)
      gpio.write(pin,gpio.LOW)  
-- Start MQTT conection to server
-- We create a client named node because client is already defined by API
-- MQTT credentials are loaded and modified on init file

  node = mqtt.Client(mqtt_idclient, 120)
  -- Set up LAST WILL and Testament if  WANTED
  node:lwt("/lwt", "offline", 0, 0)
-- Connect node object to Broker  
  node:connect( mqtt_ip , mqtt_port, 0,
  function(conn)
    print("Connected to MQTT:" .. mqtt_ip .. ":" .. mqtt_port .." as " .. mqtt_idclient )
   
    node:subscribe(mqtt_topic,0, function(conn) 
   
    -- SET tmr to go to send function every 6000 ms or as needed once connection succeded
        tmr.stop(6)
        tmr.alarm(6, 10000, 1, setstatus)
         
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
-- We create status variable so based on it we set relay status and mqtt change this variable state     
    locar status=nil     
    node:on("message", function(conn, topic, data)
    if (mqtt_topic == topic) then
      print(topic .. ":" )
      status=data
      end
    end)
    
-- setstatus reads status and sets relay based on it  
function setstatus()
if status ~= nil then
      end
      if (status == "0" ) then
    gpio.write(pin, gpio.HIGH)
    print("Switch OFF")
      end
      if (status == "1" ) then
    gpio.write(pin, gpio.LOW)
    print("Switch ON")
      end 
end

