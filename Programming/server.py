from flask import Flask, request

app = Flask(__name__)

# 🔧 Example moisture simulation
current_moisture = 25

@app.route("/command", methods=["POST"])
def command():
    global current_moisture

    data = request.data.decode()
    print("Received from ESP32:", data)

    # 🔥 Simple decision logic
    start_threshold = 30
    target_moisture = 40

    # simulate moisture rising slowly
    current_moisture += 2

    print("Current moisture:", current_moisture)

    if current_moisture < start_threshold:
        return "pump_on"
    elif current_moisture >= target_moisture:
        return "pump_off"
    else:
        return "status"

@app.route("/")
def home():
    return "Server running"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)