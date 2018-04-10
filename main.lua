

-- main.lua   Principal code for  connecting to wifi.

-- Codigo 

-- Pin mode
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.LOW)
gpio.mode(2, gpio.OUTPUT)
gpio.write(2, gpio.LOW)
-- MQTT conection    
    print("Iniciando mqtt")
    cliente = mqtt.Client(ip, keepalive, user, password, 1)
    print("Cliente iniciado")
    cliente:on("offline", function(client) print ("offline") end)

 cliente:lwt("/lwt", "offline", 0, 0)
 print("lwt configurado")
cliente:connect(ip,puerto,0,0, function(client)
  print("Conectado")
  client:subscribe("/hogar", 0, function(client) print("subscribe /hogar exito") end)
  client:subscribe("/led", 0, function(client) print("subscribe /led exito") end)
  client:publish("/hogar", "Hola hogar", 0, 0, function(client) print("mensaje enviado") end)
  conectado=1;
  end)

cliente:on("message", function(conn, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
  end
  if data == "0" then
gpio.write(4, gpio.LOW)
gpio.write(2, gpio.LOW)
  end
  if data == "1" then
gpio.write(4, gpio.HIGH)
gpio.write(2, gpio.HIGH)
  end 
end)