#include <Arduino.h>
#include "SerialCommand.h"
#include "../actuators/Actuator.h"

// Buffer for incoming command
String inputBuffer = "";

// ---------- SETUP ----------
void setupSerialCommand() {
    Serial.begin(115200);
    delay(1000);

    Serial.println("Serial Command Interface Ready");
}

// ---------- HANDLE INPUT ----------
void handleSerialCommand() {
    while (Serial.available()) {
        char c = Serial.read();

        // Echo character
        Serial.print(c);

        // Handle ENTER (both \n and \r)
        if (c == '\n' || c == '\r') {
            inputBuffer.trim();

            if (inputBuffer.length() > 0) {
                Serial.println();

                // 🔥 Send to actuator logic
                processCommand(inputBuffer);

                inputBuffer = "";
            }
        } 
        else {
            inputBuffer += c;
        }
    }
}