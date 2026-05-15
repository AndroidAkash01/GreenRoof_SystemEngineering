#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = "YOUR_WIFI";
const char* password = "YOUR_PASSWORD";

const char* mqtt_server = "YOUR_IOTHUB.azure-devices.net";

WiFiClientSecure espClient;
PubSubClient client(espClient);





void setup_wifi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
}





void reconnect() {
  while (!client.connected()) {
    client.connect("ESP32Device");
  }
}

void setup() {
  Serial.begin(115200);
  setup_wifi();

  espClient.setInsecure(); // for testing only

  client.setServer(mqtt_server, 8883);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }

  client.loop();

  int sensorValue = analogRead(34);

  String payload = "{\"moisture\": " + String(sensorValue) + "}";

  client.publish("devices/ESP32/messages/events/", payload.c_str());

  delay(5000);
}