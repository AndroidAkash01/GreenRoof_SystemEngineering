// #include <Arduino.h>
// #include <WiFi.h>

// // -------- WIFI CONFIG --------
// const char* ssid = "SneakUp_2ghz";
// const char* password = "akashebbafeb15";

// // -------- STATUS --------
// bool wifiConnected = false;

// // -------- SETUP --------
// void setupWiFi() {
//   Serial.println("Connecting to WiFi...");

//   WiFi.begin(ssid, password);

//   int retries = 0;

//   while (WiFi.status() != WL_CONNECTED && retries < 20) {
//     delay(500);
//     Serial.print(".");
//     retries++;
//   }

//   if (WiFi.status() == WL_CONNECTED) {
//     wifiConnected = true;

//     Serial.println("\n✅ WiFi connected!");
//     Serial.print("IP: ");
//     Serial.println(WiFi.localIP());
//   } else {
//     wifiConnected = false;
//     Serial.println("\n❌ WiFi connection failed");
//   }
// }

// // -------- CHECK CONNECTION --------
// void checkWiFi() {
//   if (WiFi.status() != WL_CONNECTED) {
//     wifiConnected = false;

//     Serial.println("⚠️ WiFi lost. Reconnecting...");
//     WiFi.begin(ssid, password);
//   } else {
//     wifiConnected = true;
//   }
// }

// // -------- GET STATUS --------
// bool isWiFiConnected() {
//   return wifiConnected;
// }