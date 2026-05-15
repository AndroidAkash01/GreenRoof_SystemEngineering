import serial 
import time

# 🔧 Change this to your port
PORT = "/dev/cu.usbserial-14430"
BAUDRATE = 115200

def main():
    try:
        ser = serial.Serial(PORT, BAUDRATE, timeout=1)
        time.sleep(2)  # allow ESP32 to reset

        print("✅ Connected to ESP32")
        print("Type commands (pump_on, pump_off, valve_on, valve_off, status)")
        print("Type 'exit' to quit\n")

        while True:
            cmd = input("Enter command: ")

            if cmd.lower() == "exit":
                break

            # 🔥 send command with newline
            ser.write((cmd + "\n").encode())

            time.sleep(0.2)

            # 🔍 read response
            while ser.in_waiting:
                response = ser.readline().decode(errors='ignore').strip()
                if response:
                    print("ESP32:", response)

    except Exception as e:
        print("❌ Error:", e)

    finally:
        try:
            ser.close()
        except:
            pass
        print("Connection closed")


if __name__ == "__main__":
    main()