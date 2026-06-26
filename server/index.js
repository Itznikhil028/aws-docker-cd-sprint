const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = 5000;
const MONGO_URL = 'mongodb://database:27017';

app.use(express.json());

let dbClient = null;
let userCollection = null;

async function initializeDatabase() {
    try {
        console.log("[Day 87] Establishing global persistent MongoDB connection pool...");
        dbClient = await MongoClient.connect(MONGO_URL, { serverSelectionTimeoutMS: 10000 });
        const db = dbClient.db('devops_sprint_db');
        userCollection = db.collection('users');
        console.log("[SUCCESS] Global MongoDB connection pool locked and active!");
    } catch (error) {
        console.error("[CRITICAL] Database initialization failed:", error.message);
        console.log("Retrying database pool in 3 seconds...");
        setTimeout(initializeDatabase, 3000);
    }
}

initializeDatabase();

app.use((req, res, next) => {
    if (!userCollection) {
        return res.status(503).json({ error: "Database service temporarily unavailable" });
    }
    next();
});

app.get('/api/status', async (req, res) => {
    try {
        const db = dbClient.db('admin');
        const pingResult = await db.command({ ping: 1 });
        res.status(200).json({ status: "healthy", connectionPool: "Active", ping: pingResult });
    } catch (error) {
        res.status(500).json({ status: "error", message: error.message });
    }
});

app.post('/api/users', async (req, res) => {
    const { name, role, day } = req.body;
    if (!name || !role) {
        return res.status(400).json({ error: "Name and Role fields are required!" });
    }
    try {
        const newUser = { name, role, day: day || 87, createdAt: new Date() };
        const result = await userCollection.insertOne(newUser);
        res.status(201).json({
            message: "Data successfully written via Pool!",
            insertedId: result.insertedId,
            userData: newUser
        });
    } catch (error) {
        res.status(500).json({ error: "Write operation failed: " + error.message });
    }
});

app.get('/api/users', async (req, res) => {
    try {
        const usersList = await userCollection.find({}).toArray();
        res.status(200).json(usersList);
    } catch (error) {
        res.status(500).json({ error: "Read operation failed: " + error.message });
    }
});

app.listen(PORT, () => {
    console.log(`[🚀 DAY 87 POOL LIVE] Production API gateway running on port ${PORT}`);
});
