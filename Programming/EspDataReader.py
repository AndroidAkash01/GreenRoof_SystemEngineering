import serial
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

 

def read_from_esp():
    while True:
        try:
            # Check if serial is actually open
            if ser.is_open and ser.in_waiting:
                line = ser.readline().decode(errors='ignore').strip()
                if not line:
                    continue

                parts = line.split(",")
                
                # Logic: If 3 parts, it's data. If not, it's a message.
                if len(parts) == 3:
                    try:
                        temp = float(parts[0])
                        humidity = float(parts[1])
                        moisture = int(parts[2])
                        print(f"{YELLOW}🌡 Temp: {temp}°C | 💧 Humidity: {humidity}% | 🌱 Moisture: {moisture}%{RESET}")
                        
                        # Uncomment this to actually send to your dashboard!
                        # ws.send(f"DATA:{temp},{humidity},{moisture}")
                    except ValueError:
                        print("🤖 ESP Message:", line)
                else:
                    if line: print("🤖 ESP Message:", line)

        except serial.SerialException as e:
            print("⚠️ Port Busy or Disconnected. Is VS Code Serial Monitor open?")
            time.sleep(2)
        except Exception as e:
            print(f"⚠️ Unexpected error: {e}")
            time.sleep(0.5)



if __name__ == "__main__":
    read_from_esp()