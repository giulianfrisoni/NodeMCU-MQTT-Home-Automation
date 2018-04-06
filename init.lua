
--init.lua  Archivo principal que bootloader intentara corren
--          en inicio, de el iniciar wifi-y codigo funcional
--          Este es guardado en memoria flash de la NodeMCu
-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile("credenciales")
print("Conectando a Wifi...")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD) --Valores asignados a memoria por dofile(credenciales)
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
  if wifi.sta.getip() == nil then
    print("Esperando direccion IP...")
  else
    tmr.stop(1)
    print("Conexion estalbecida, IP : " .. wifi.sta.getip())
    print("Tres segundos para abortar inicio")
    print("Esperando...")
    tmr.alarm(0, 3000, 0, inicio) --Esperar tres segundos
  end
end)

function inicio()
  if file.open("init") == nil then
    print("init.lua borrada o renombrada")
  else
    print("Iniciando")
    file.close("init")
   dofile("main")
  end
end
Main.lua
-- mqtt.lua   Codigo principal para el Funcionamiento de
--              Conexiones, MQTT,relay
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
