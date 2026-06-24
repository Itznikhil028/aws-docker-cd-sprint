const net = require('net');

const HOST = 'database';
const PORT = 27017;
let retryCount = 1;

function connectWithRetry() {
    console.log(`[Day 85 API] (Attempt ${retryCount}) Connection check to MongoDB at ${HOST}:${PORT}...`);
    
    const client = new net.Socket();
    
    client.connect(PORT, HOST, () => {
        console.log(`[SUCCESS] Connected to MongoDB internal cluster mesh successfully!`);
        client.destroy();
    });

    client.on('error', (err) => {
        console.error(`[RETRY] Database not fully booted yet. Retrying in 2 seconds...`);
        client.destroy();
        retryCount++;
        setTimeout(connectWithRetry, 2000); // 2 second ka gap dekar dubara call karega
    });
}

// Pehli baar function run karo
connectWithRetry();

// Runtime hold loop
setInterval(() => {}, 1000);
