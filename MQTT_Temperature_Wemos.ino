// Authors: Daniela Beckmann Garcia % Giulian Frisoni
// Code generated for Wemos UNO 
// Use of SimpleDHT for sensor reads and PubSubClient for MQTT comm.
// ESP8266wifi is neccesary as it provides the arduino with control over the 8266 Wifi Chipset 
#include <SimpleDHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Credentials of Wifi and MQTT server
const char* ssid     = "YOU SSID HERE";
const char* password = "Wifi password here";
const char* mqtt_server = "Mqtt server local IP";
// Define temp and hum as char arrays
char temp[50];
char hum[50];
// Sensor selected for sensor reading
#define sensorpin D8

// Create dht11 and espclient objects and pass client to library.
SimpleDHT11 dht11;
WiFiClient espClient;
PubSubClient client(espClient);

// Variables for messages storing
long lastMsg = 0;
char msg[50];
int value = 0;

// Setup code
void setup() {
  // Remove serial code for performance after testing
  Serial.begin(115200);
  delay(10);

  //  Connect to a WiFi network
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500)
  }
  
    // Once Wifi is setup connect to MQTT local server
    client.setServer(mqtt_server, <port>); 
    }

void reconnect() {
  // Recconection loop until is succesful
  while (!client.connected()) {
    Serial.print("Starting MQTT connection...");
    // Try to connect
    if (client.connect("<Client name>","<user name>","<user password>")) {
      Serial.println("connected");
      
      // After connection is succesful publish a message of connection success via network if wanted.
      //  <publish code here>
      // ... and resubscribe
    
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 6 seconds");
      // Wait 6 seconds before retrying
      delay(6000);
    }
  }
}


void loop() {
  // Check for client connection if not reconnect
  if (!client.connected()) {
    reconnect();
  }
  
  // Allow server to refresh and publish messages.
  client.loop();    
  
  // Sensor  temperature and humidity read
  byte temperature = 0;
  byte humidity = 0;
  
  int err = SimpleDHTErrSuccess;
  
  if ((err = dht11.read(sensorpin, &temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Sensor reading failed, error ="); Serial.println(err);delay(1000);
    return;
  }
  
  // After reading data prepare data  for sending
  
   String pubString = String(temperature); 
   String pubString2 = String(humidity); 
 pubString.toCharArray(temp, pubString.length()+1); 
 pubString2.toCharArray(hum, pubString2.length()+1); 
 
  // Send data via MQTT to a specified topic
   client.publish("<topic here>", temp);
   client.publish("<topic here>", hum);
  
  

  delay(15000);
}
