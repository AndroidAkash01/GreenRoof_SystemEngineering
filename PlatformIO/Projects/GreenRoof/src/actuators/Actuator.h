#pragma once
#include <Arduino.h>

void setupActuator();
void processCommand(String cmd);
bool isPumpOn();
int getPumpOnTime(); 