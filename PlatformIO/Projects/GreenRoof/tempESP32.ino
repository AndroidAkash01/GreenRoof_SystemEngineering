#include "DHT.h"

#define DHTPIN 4       // GPIO pin connected to DATA
#define DHTTYPE DHT22  // AM2301B is compatible with DHT21/DHT22

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200);
  dht.begin();
  Serial.println("AM2301B Test");
}

void loop() {
  float temp = dht.readTemperature();   // Celsius
  float hum = dht.readHumidity();

    Serial.print("Temperature: ");
    Serial.print(temp);
    Serial.print(" °C, Humidity: ");
    Serial.print(hum);
    Serial.println(" %");
    delay(1000);
  }
  
