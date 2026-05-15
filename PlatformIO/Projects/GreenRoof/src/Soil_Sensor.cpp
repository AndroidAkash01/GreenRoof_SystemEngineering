#include <Arduino.h>
#include "Soil_Sensor.h"

#define SOIL_PIN 1 

int readSoil() {
    int value = analogRead(SOIL_PIN);
    int moisture = map(value, 0, 4095, 100, 0); 
    return constrain(moisture, 0, 100);
}