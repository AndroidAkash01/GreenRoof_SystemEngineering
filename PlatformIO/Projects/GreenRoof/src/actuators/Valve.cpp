#include <Arduino.h>
#include "../wiring/Wiring.h"

bool valveState = false;

void setupValve() {
  pinMode(VALVE_PIN, OUTPUT);
  digitalWrite(VALVE_PIN, RELAY_OFF);
}

void valveOn() {
  digitalWrite(VALVE_PIN, RELAY_ON);
  valveState = true;
}

void valveOff() {
  digitalWrite(VALVE_PIN, RELAY_OFF);
  valveState = false;
}

bool getValveState() {
  return valveState;
}