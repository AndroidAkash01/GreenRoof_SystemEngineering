#ifndef STORAGE_H
#define STORAGE_H

#include <Arduino.h>

void initStorage();
void saveData(float temp, float hum, int soil);
void printStoredData(); // optional debug
void flushStoredData();   // 🔥 NEW (print + clear)
bool hasStoredData();     // 🔥 NEW

#endif