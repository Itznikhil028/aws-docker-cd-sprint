const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = 5000;
const MONGO_URL = 'mongodb://database:27017';

app.use(express.json());

app.get('/api/status', async (req, res) => {
    let client;
    try {
        // Timeout increased to 10000ms for stable resolution
        client = await MongoClient.connect(MONGO_URL, { serverSelectionTimeoutMS: 10000 });
        const adminDb = client.db('admin');
        const pingResult = await adminDb.command({ ping: 1 });
        
        res.status(200).json({
            status: "healthy",
            framework: "Express.js",
            database: "MongoDB Connected Securely",
            ping: pingResult
        });
    } catch (error) {
        console.error("[ROUTE ERROR]", error.message);
        res.status(500).json({ 
            status: "error", 
            message: "Database resolution failed: " + error.message 
        });
    } finally {
        if (client) {
            await client.close();
        }
    }
});

app.listen(PORT, () => {
    console.log(`[🚀 API LIVE] Express gateway running on port ${PORT}`);
});
