#include <Arduino.h>
#include "IrrigationController.h"
#include "../actuators/Actuator.h"

// ---- CONFIG ----
const int MIN_MOISTURE = 30;
const int MAX_MOISTURE = 45;
const unsigned long MAX_RUN_TIME = 30000;

// ---- STATE ----
static unsigned long pumpStartTime = 0;
static int lastMoisture = 0;
static unsigned long lastCheckTime = 0;
static bool isIrrigating = false;

void updateIrrigation(float temp, float hum, int moisture, bool dhtSuccess) {

    bool safetyStop = false;

    // 🔥 SAFETY CHECKS

    // Over-irrigation
    if (moisture >= MAX_MOISTURE) {
        safetyStop = true;
        Serial.println("⚠️ Safety: Over-moisture");
    }

    // Max runtime
    if (isIrrigating && millis() - pumpStartTime > MAX_RUN_TIME) {
        safetyStop = true;
        Serial.println("⚠️ Safety: Max runtime exceeded");
    }

    // Dry-run detection
    if (isIrrigating && millis() - lastCheckTime > 10000) {
        if (abs(moisture - lastMoisture) < 1) {
            safetyStop = true;
            Serial.println("⚠️ Safety: Dry-run detected");
        }
        lastMoisture = moisture;
        lastCheckTime = millis();
    }

    // Sensor failure
    if (!dhtSuccess || moisture <= 0) {
        safetyStop = true;
        Serial.println("⚠️ Safety: Sensor failure");
    }

    // 🔴 APPLY SAFETY
    if (safetyStop) {
        if (isIrrigating) {
            processCommand("pump_off");
            processCommand("valve_off");
            isIrrigating = false;
        }
        return;
    }

    // 🧠 NORMAL LOGIC

    // START irrigation
    if (moisture < MIN_MOISTURE && !isIrrigating) {
        processCommand("pump_on");
        processCommand("valve_on");

        isIrrigating = true;
        pumpStartTime = millis();

        Serial.println("🌱 Irrigation START");
    }

    // STOP irrigation
    if (moisture >= MAX_MOISTURE && isIrrigating) {
        processCommand("pump_off");
        processCommand("valve_off");

        isIrrigating = false;

        Serial.println("💧 Irrigation STOP");
    }
}