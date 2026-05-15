#include "Storage.h"

#define MAX_RECORDS 100

struct DataRecord {
    float temp;
    float hum;
    int soil;
};

DataRecord buffer[MAX_RECORDS];
int indexPos = 0;

void initStorage() {
    indexPos = 0;
}

void saveData(float temp, float hum, int soil) {
    if (indexPos >= MAX_RECORDS) {
        indexPos = 0; // circular overwrite
    }

    buffer[indexPos].temp = temp;
    buffer[indexPos].hum = hum;
    buffer[indexPos].soil = soil;

    indexPos++;

    Serial.println("💾 Data saved locally");
}

bool hasStoredData() {
    return indexPos > 0;
}

void flushStoredData() {
    Serial.println("📤 Sending stored data...");

    for (int i = 0; i < indexPos; i++) {
        Serial.print(buffer[i].temp);
        Serial.print(",");
        Serial.print(buffer[i].hum);
        Serial.print(",");
        Serial.println(buffer[i].soil);
    }

    // 🔥 CLEAR BUFFER AFTER SENDING
    indexPos = 0;

    Serial.println("🧹 Buffer cleared");
}