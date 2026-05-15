# main.py
import threading
import time
import python_client 
from PlantSystem import PlantSystem

# 🎯 THE INTERFACE IMPLEMENTATION


def main():
    # 1. Create the implementation object
    my_plant = PlantSystem()

    # 2. Start the gateway and PASS the object reference
    gateway_thread = threading.Thread(
        target=python_client.run_gateway, 
        args=(my_plant,), 
        daemon=True
    )
    gateway_thread.start()

    print("✅ System Started. Linked to PlantSystem interface.")

    while True:
        # You can still access the object safely here in the main loop
        if my_plant.soil < 30 and my_plant.soil > 0:
            print("🧠 Main Thread Logic: Condition met, check system...")
        time.sleep(10)

if __name__ == "__main__":
    main()



 