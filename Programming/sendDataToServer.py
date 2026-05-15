import requests

def send_data_to_server(data):
    url = "https://www.alfatap.com/GreenRoof/logData.php"

    payload = {
        "key": "greenroof123",
        "data": data
    }

    try:
        response = requests.post(url, data=payload, timeout=5)
        print("🌐 Server response:", response.text)
    except Exception as e:
        print("❌ Failed to send data:", e)