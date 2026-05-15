 // ---------------- OPTIONAL MYSQL SETUP ----------------
// 👉 Install first: npm install mysql2
/*
const mysql = require('mysql2');

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "YOUR_PASSWORD",
    database: "irrigation"
});

db.connect(err => {
    if (err) console.log("❌ DB error:", err);
    else console.log("✅ MySQL connected");
});

// 🔥 BUFFER for batching data (5 min storage)
let buffer = [];
*/

// ---------------- SAVE FUNCTION (EDIT AS NEEDED) ----------------
/*
function saveBufferToDatabase() {
    if (buffer.length === 0) return;

    console.log("💾 Saving", buffer.length, "records");

    const values = buffer.map(d => [
        d.temperature || null,
        d.humidity || null,
        d.moisture || null,
        new Date()
    ]);

    db.query(
        "INSERT INTO sensor_data (temperature, humidity, moisture, created_at) VALUES ?",
        [values],
        (err) => {
            if (err) console.log("❌ DB insert error:", err);
            else console.log("✅ Data saved");

            buffer = []; // clear after save
        }
    );
}

// 🔥 AUTO SAVE EVERY 5 MINUTES
setInterval(saveBufferToDatabase, 5 * 60 * 1000);
*/

// ---------------- WEBSOCKET ----------------
 
const WebSocket = require('ws');

const wss = new WebSocket.Server({
    host: '0.0.0.0',
    port: 8080
});

let pythonClient = null;
let clients = [];

wss.on('connection', (ws, req) => {
    console.log("Client connected from", req.socket.remoteAddress);

    clients.push(ws);

    ws.on('message', (message) => {
        const msg = message.toString().trim();
        console.log("📩 Received:", msg);

        if (msg === "PYTHON_CLIENT") {
            pythonClient = ws;
            console.log("🐍 Python client registered");
            return;
        }

        if (msg.startsWith("DATA:")) {
            clients.forEach(client => {
                if (client !== pythonClient && client.readyState === WebSocket.OPEN) {
                    client.send(msg);
                }
            });
            return;
        }

        if (pythonClient && pythonClient.readyState === WebSocket.OPEN) {
            pythonClient.send(msg);
        } else {
            console.log("⚠ No Python client connected");
        }
    });

    ws.on('close', () => {
        clients = clients.filter(client => client !== ws);

        if (ws === pythonClient) {
            pythonClient = null;
            console.log("⚠ Python client disconnected");
        }
    });
});

console.log("🔥 WebSocket server running on 0.0.0.0:8080");