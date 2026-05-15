#include <Arduino.h>
#include "../wiring/Wiring.h"

bool pumpState = false;



void setupPump() {
  pinMode(PUMP_PIN, OUTPUT);
  digitalWrite(PUMP_PIN, RELAY_OFF);
}

void pumpOn() {
  digitalWrite(PUMP_PIN, RELAY_ON);
  pumpState = true;
   
}

void pumpOff() {
  digitalWrite(PUMP_PIN, RELAY_OFF);
  pumpState = false;
}

bool getPumpState() {
  return pumpState;
}