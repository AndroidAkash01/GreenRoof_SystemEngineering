import websocket
import serial
import time
import threading
import json # Add this at the top
from datetime import datetime
import time

# ---------- CONFIG ----------
PORT = "/dev/cu.usbserial-14430"
BAUD = 115200
WS_URL = "ws://167.71.41.77:8080"

# ANSI COLORS
YELLOW = "\033[93m"
RESET = "\033[0m"

ser = serial.Serial(PORT, BAUD, timeout=1)
time.sleep(2)

print("✅ Connected to ESP32 via USB")

# ---------- FROM SERVER ----------
def on_message(ws, message):
    print("🌐 Received from server:", message)

    # ✅ ONLY SEND VALID COMMANDS TO ESP
    if message in ["pump_on", "pump_off", "valve_on", "valve_off", "status"]:
        ser.write((message + "\n").encode())
    else:
        print("🚫 Ignored non-command")


latest_data = {"temp": 0.0, "humidity": 0.0, "moisture": 0}

# This will hold the object once run_gateway is called
app_interface = None 

 

def read_from_esp(ws):
    global latest_data  
    while True:
        try:
            if ser.is_open and ser.in_waiting:
                line = ser.readline().decode(errors='ignore').strip()
                if not line: continue
                if line: 
                    ser.write(b"ACK\n")
                #Once connection is established, send ser.write(("Send_Log" + "\n").encode())
                # Line should contain "LOG" as first 3 letters 
                # Print the log message with a timestamp 
                # It ends with LOG_END the rest of the part of code works
                

                parts = line.split(",")
                if len(parts) == 3:
                    try:
                        # 🎯 Update the shared dictionary
                        latest_data["temp"] = float(parts[0])
                        latest_data["humidity"] = float(parts[1])
                        latest_data["moisture"] = int(parts[2])
                        if app_interface:
                         app_interface.update(float(parts[0]), float(parts[1]), int(parts[2]))
                        
                        # (Optional) keep your print for debugging
                        # print(f"Update: {latest_data}") 
                    except ValueError:
                        print("🤖 ESP Message:", line)
                # else:
                    # if line: print("🤖 ESP Message:", line)
            time.sleep(0.1) # Small sleep to save CPU
        except Exception as e:
            print(f"⚠️ Error: {e}")
            time.sleep(1)



            

# ---------- CONNECT ----------
def on_open(ws):
    print("🔌 Connected to WebSocket server")

    ws.send("PYTHON_CLIENT")

    threading.Thread(target=read_from_esp, args=(ws,), daemon=True).start()

def on_close(ws, close_status_code, close_msg):
    print("❌ WebSocket disconnected")
    threading.Thread(target=read_from_esp, args=(ws,), daemon=True).start()

def on_error(ws, error):
    print("⚠️ Error:", error)
    threading.Thread(target=read_from_esp, args=(ws,), daemon=True).start()


ws = websocket.WebSocketApp(
    WS_URL,
    on_message=on_message,
    on_open=on_open,
    on_close=on_close,
    on_error=on_error
)

# print("🚀 Connecting...")
# ws.run_forever()


def run_gateway(obj_ref):
    global app_interface
    app_interface = obj_ref

    """This function will be called by your main file"""
    print("🚀 Connecting to WebSocket...")
    ws.run_forever()