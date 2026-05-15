// #include <Arduino.h>
// #include <WiFi.h>
// #include "WiFiAP.h"
// #include "../actuators/Actuator.h"

// // WiFi credentials
// const char* ssid = "ESP32_AP";
// const char* password = "12345678";

// // Create server on port 80
// WiFiServer server(80);

// // ---------- SETUP ----------
// void setupWiFiAP() {
//   WiFi.softAP(ssid, password);

//   IPAddress IP = WiFi.softAPIP();

//   Serial.println("ESP32 Access Point Started");
//   Serial.print("IP Address: ");
//   Serial.println(IP);

//   server.begin();
// }

// // ---------- HANDLE CLIENT ----------
// void handleWiFiClients() {
//   WiFiClient client = server.available();

//   if (client) {
//     Serial.println("Client connected");

//     String request = "";

//     while (client.connected()) {
//       if (client.available()) {
//         char c = client.read();
//         request += c;

//         // End of HTTP request
//         if (c == '\n') {
//           break;
//         }
//       }
//     }

//     // Extract command from request
//     Serial.print("RAW REQUEST: ");
//     Serial.println(request);

//     String cmd = "";

//     // Example: GET /pump_on HTTP/1.1
//     int start = request.indexOf("GET /") + 5;
//     int end = request.indexOf(" HTTP");

//     if (start > 4 && end > start) {
//       cmd = request.substring(start, end);
//     }

//     Serial.print("COMMAND: ");
//     Serial.println(cmd);

//     if (cmd.length() > 0) {
//       processCommand(cmd);   // 🔥 reuse your actuator logic
//     }

//     // Send response
//     client.println("HTTP/1.1 200 OK");
//     client.println("Content-type:text/plain");
//     client.println();
//     client.println("OK");
//     client.println();

//     client.stop();
//     Serial.println("Client disconnected");
//   }
// }