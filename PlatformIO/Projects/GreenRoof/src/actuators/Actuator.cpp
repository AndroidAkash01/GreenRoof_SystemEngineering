#include <Arduino.h>
#include "Pump.h"
#include "Valve.h"
#include "Actuator.h"

// ---------- SETUP ----------
void setupActuator() {
    setupPump();
    setupValve();

    Serial.println("Actuator system ready");
}

int pumpOnTime =   0;

bool isPumpOn() {
    return getPumpState();
}

int getPumpOnTime(){
    return pumpOnTime;
}

// ---------- COMMAND PROCESSING ----------
void processCommand(String cmd) {

    cmd.trim();
    cmd.replace("\r", "");
    cmd.replace("\n", "");
    cmd.toLowerCase();

    Serial.print("CMD RECEIVED: [");
    Serial.print(cmd);
    Serial.println("]");

    // -------- PUMP --------
    if (cmd.indexOf("pump_on") >= 0) {
        pumpOn();
        Serial.println("PUMP:ON");
        pumpOnTime = millis();
    }
    else if (cmd.indexOf("pump_off") >= 0) {
        pumpOff();
        Serial.println("PUMP:OFF");
         
    }

    // -------- VALVE --------
    else if (cmd.indexOf("valve_on") >= 0) {
        valveOn();
        Serial.println("VALVE:ON");
    }
    else if (cmd.indexOf("valve_off") >= 0) {
        valveOff();
        Serial.println("VALVE:OFF");
    }

    // -------- STATUS --------
    else if (cmd.indexOf("status") >= 0) {
        Serial.print("PUMP:");
        Serial.println(getPumpState() ? "ON" : "OFF");

        Serial.print("VALVE:");
        Serial.println(getValveState() ? "ON" : "OFF");
    }

    else {
        Serial.println("UNKNOWN_CMD");
    }
}