#include <SimpleDHT.h>




#define sensorpin D8
SimpleDHT11 dht11;
void setup() {
  
   Serial.begin(115200);
  // put your setup code here, to run once:

}

void loop() {
   Serial.println("=================================");
  Serial.println("Sample DHT11...");
  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  if ((err = dht11.read(sensorpin, &temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT11 failed, err="); Serial.println(err);delay(1000);
    return;
  }
  
  Serial.print("Sample OK: ");
  Serial.print((int)temperature); Serial.print(" *C, "); 
  Serial.print((int)humidity); Serial.println(" H");
  
  // DHT11 sampling rate is 1HZ.
  delay(5000);
}
