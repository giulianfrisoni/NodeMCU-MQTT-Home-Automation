

#include <SimpleDHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

const char* ssid     = "INFINITUMF05E";
const char* password = "1539358075";
const char* mqtt_server = "192.168.1.74";
char temp[50];
char hum[50];
#define sensorpin D8
SimpleDHT11 dht11;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int value = 0;

void setup() {
  Serial.begin(115200);
  delay(10);

  // We start by connecting to a WiFi network

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());  
  client.setServer(mqtt_server, 1883); 
}
void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("NodoTemp","hogar","4511")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
     
      // ... and resubscribe
    
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}
void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();    Serial.println("=================================");
  Serial.println("Sample DHT11...");
  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  if ((err = dht11.read(sensorpin, &temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT11 failed, err="); Serial.println(err);delay(1000);
    return;
  }
   String pubString = String(temperature); 
   String pubString2 = String(humidity); 
 pubString.toCharArray(temp, pubString.length()+1); 
 pubString2.toCharArray(hum, pubString2.length()+1); 
 //Serial.println(pubString); 
   client.publish("/hogar/temperatura", temp);
   client.publish("/hogar/humedad", hum);
  Serial.print("Sample OK: ");
  Serial.print((int)temperature); Serial.print(" *C, "); 
  Serial.print((int)humidity); Serial.println(" H");
  delay(15000);
}
