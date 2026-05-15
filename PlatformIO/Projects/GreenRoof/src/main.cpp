#include <Arduino.h>
#include "actuators/Actuator.h"
#include "communication/SerialCommand.h"
#include "DHT_Sensor.h"
#include "Soil_Sensor.h"
#include "storage/Storage.h"   // 🔥 NEW
#include "logic/IrrigationController.h"

unsigned long lastAckTime = 0;
bool wasDisconnected = false;  // 🔥 TRACK STATE

int initialSoilMoisture = 0;

 
void setup() {
    Serial.begin(115200);
    setupSerialCommand();
    setupActuator();
    setupDHT();
    analogReadResolution(12); // Put this here, only once
    initStorage(); // 🔥 NEW
    initialSoilMoisture = readSoil();
 

}
 
int minSafetyTime = 10; // Seconds

int minSafetyTimeMoisture = 4; // Seconds

int timeAgo         = minSafetyTime * 1000; // 30 seconds in milliseconds
int timeAgoMoisture = minSafetyTimeMoisture * 1000; // 30 seconds in milliseconds

void loop() {
    handleSerialCommand();

    int currentTime = millis();

    bool isConnected = (currentTime - lastAckTime <= 5000);



    wasDisconnected = !isConnected;
 
    // Saftey check

    // // check if pump is on 
    // if (getPumpOnTime() < (currentTime-timeAgo)) {
    //     Serial.println("⚠️ Pump has been on for too long! Turning off for safety.");
    //     processCommand("pump_off");  
    // }

    // // check current soil moisture

    // if((readSoil() - initialSoilMoisture) < 5 ){

    //     if (getPumpOnTime() < (currentTime-timeAgoMoisture)) {
    //         Serial.println("⚠️ Pump has been on for too long! Turning off for safety.");
    //         processCommand("pump_off");  
    //     }
 
    // }



 

    static unsigned long lastSend = 0;
    if (millis() - lastSend > 2000) {
        lastSend = millis();

        float temp = 0, hum = 0;
        bool dhtSuccess = readDHT(temp, hum);
        
        int moisture = readSoil(); 

        if (dhtSuccess) {
            Serial.print(temp);
            Serial.print(",");
            Serial.print(hum);
            Serial.print(",");
            Serial.println(moisture); 
        } else {
            Serial.println("0.0,0.0,0"); 
        }

        if (!isConnected) {
            Serial.println("Not Connected");

            // 🔥 STORE DATA
            if (dhtSuccess) {
                saveData(temp, hum, moisture);
            }
        }
    }
}



















// #include <Arduino.h>
// #include "actuators/Actuator.h"
// #include "communication/SerialCommand.h"

// void setup() {
//     setupSerialCommand();  // start Serial
//     setupActuator();       // setup pump + valve
// }

// void loop() {
//     handleSerialCommand(); // keep this

//     static unsigned long lastSend = 0;

//     // 🔥 SEND EVERY 2 SECONDS
//     if (millis() - lastSend > 2000) {
//         lastSend = millis();

//         // 🔥 Dummy values
//         int temp = random(20, 30);
//         int humidity = random(40, 70);
//         int moisture = random(300, 800);

//         // 🔥 SIMPLE FORMAT (NO JSON)
//         // FORMAT: temp,humidity,moisture
//         Serial.print(temp);
//         Serial.print(",");
//         Serial.print(humidity);
//         Serial.print(",");
//         Serial.println(moisture);
//     }
// }

 

 