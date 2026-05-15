import time
from datetime import datetime
from sendDataToServer import send_data_to_server

import os

class PlantSystem:
    def __init__(self):
        self.temp = 0.0
        self.hum = 0.0
        self.soil = 0

        self.pump_on = False
        self.valve_open = False

        self.irrigation_start_time = None
        self.total_water_used = 0.0  # liters

        # 💧 Pump flow rate (example: 2 L/min)
        self.FLOW_RATE_L_PER_SEC = 2 / 60

        # 📄 Log file
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))

        self.log_file = os.path.join(BASE_DIR, "irrigation_log.txt")
        self.datafile = os.path.join(BASE_DIR, "sensor_data.txt")
        


    def update(self, t, h, s):
        """Called whenever new sensor data arrives"""
        self.temp = t
        self.hum = h
        self.soil = s

        self.on_new_data()
        self.control_logic()

    def on_new_data(self):
        print(f"\033[93m⚡ Instant Update -> Soil: {self.soil}% | Temp: {self.temp}°C | Humidity: {self.hum}%\033[0m")
        # Save this data inside the logfile with timestamp
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_message = f"[{timestamp}] Instant Update -> Soil: {self.soil}% | Temp: {self.temp}°C | Humidity: {self.hum}%"
        data = f"T:[{self.temp}], H:[{self.hum}], S:[{self.soil}]"
        print(log_message)
        self.log(data)
        self.logData(data)
        data = f"[{timestamp}][T:[{self.temp}], H:[{self.hum}], S:[{self.soil}]]"

        send_data_to_server(data)
        

    # ---------------------------- LOGGING ----------------------------
    def log(self, message):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        full_msg = f"[{timestamp}] {message}"

        # Console
        print(full_msg)

        # File
        with open(self.log_file, "a") as f:
            f.write(full_msg + "\n")

    def logData(self, message):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        full_msg = f"[{timestamp}][{message}]"

        # Console
        print(full_msg)

        # File
        with open(self.datafile, "a") as f:
            f.write(full_msg + "\n")

    # ---------------------------- CONTROL LOGIC ----------------------------
    def control_logic(self):
        decision = ""

        # 🌵 DRY → START IRRIGATION
        if self.soil < 35:
            decision = "START_IRRIGATION"
            self.log(f"Soil={self.soil}% → Decision: {decision}")
            self.start_irrigation()

        # 🌊 ENOUGH → STOP IRRIGATION
        elif self.soil >= 55:
            decision = "STOP_IRRIGATION"
            self.log(f"Soil={self.soil}% → Decision: {decision}")
            self.stop_irrigation()

        else:
            decision = "NO_ACTION"
            self.log(f"Soil={self.soil}% → Decision: {decision}")

    # ---------------------------- ACTIONS ----------------------------
    def start_irrigation(self):
        if not self.pump_on:
            self.log("💧 ACTION: Valve OPEN")
            self.log("💧 ACTION: Pump ON")

            self.pump_on = True
            self.valve_open = True
            self.irrigation_start_time = time.time()

    def stop_irrigation(self):
        if self.pump_on:
            duration = time.time() - self.irrigation_start_time

            water_used = duration * self.FLOW_RATE_L_PER_SEC
            self.total_water_used += water_used

            self.log("🛑 ACTION: Pump OFF")
            self.log("🛑 ACTION: Valve CLOSED")

            self.log(f"⏱️ Irrigation time: {duration:.2f} sec")
            self.log(f"💧 Water used: {water_used:.3f} L")
            self.log(f"📊 Total water used: {self.total_water_used:.3f} L")

            self.pump_on = False
            self.valve_open = False
            self.irrigation_start_time = None