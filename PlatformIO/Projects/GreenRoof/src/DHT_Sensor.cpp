#include "DHT_Sensor.h"
#include <Wire.h>
#include <Adafruit_AHTX0.h>

// Specific pins for your ESP32-S2-DevKitM-1
#define I2C_SDA 8
#define I2C_SCL 9

Adafruit_AHTX0 aht;

void setupDHT() {
    // Initialize I2C with the specific S2 pins
    if (!Wire.begin(I2C_SDA, I2C_SCL)) {
        Serial.println("Failed to initialize I2C bus!");
        return;
    }

    if (!aht.begin()) {
        Serial.println("Could not find AM2301B (AHT20) sensor!");
    } else {
        Serial.println("AM2301B initialized.");
    }
}

bool readDHT(float &temperature, float &humidity) {
    sensors_event_t humidity_event, temp_event;
    
    // Attempt to get the reading
    if (aht.getEvent(&humidity_event, &temp_event)) {
        temperature = temp_event.temperature;
        humidity = humidity_event.relative_humidity;
        return true;
    }
    
    return false; // Return false if the sensor fails to respond
}
