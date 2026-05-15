#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "../actuators/Actuator.h"
#include "WiFiClientManager.h"

// 🔧 Change to your Mac hotspot name
const char* ssid = "MacServer";
const char* password = "12345678";

// 🔧 Change to your Mac IP
const char* serverUrl = "http://172.20.10.2:5050/command";
// ---------- SETUP ----------
 void setupWiFiClient() {
  WiFi.begin(ssid, password);

  Serial.print("Connecting to WiFi");

  int retries = 0;

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");

    retries++;

    if (retries > 30) {
      Serial.println("\n❌ Failed to connect!");
      Serial.print("Status: ");
      Serial.println(WiFi.status());
      return;
    }
  }

  Serial.println("\n✅ Connected!");
  Serial.print("ESP32 IP: ");
  Serial.println(WiFi.localIP());
}
// ---------- COMMUNICATION ----------
void handleServerCommunication() {
  if (WiFi.status() == WL_CONNECTED) {

    HTTPClient http;

    http.begin(serverUrl);
    http.addHeader("Content-Type", "text/plain");

    // 🔧 For now just send dummy value (later replace with sensor)
    String payload = "status";

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      String response = http.getString();

      Serial.print("Server response: ");
      Serial.println(response);

      // 🔥 IMPORTANT: call actuator logic
      processCommand(response);
    } 
    else {
      Serial.print("HTTP Error: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  }

  delay(5000); // every 5 sec
}