const AWS = require('aws-sdk');
const { MongoClient } = require('mongodb');
const express = require('express');
const path = require('path');

const app = express();
app.use(express.static('public'));

// SSM client
const ssm = new AWS.SSM({ region: 'us-east-1' }); // حطي region بتاعك

async function getMongoURI() {
    const param = await ssm.getParameter({
        Name: '/fatma-app/mongo-uri', // اسم الباراميتر بتاعك
        WithDecryption: true
    }).promise();
    return param.Parameter.Value;
}

async function run() {
    try {
        const uri = await getMongoURI();
        const client = new MongoClient(uri);
        await client.connect();
        console.log("Connected to MongoDB Atlas via SSM!");

        const db = client.db("fatmaDB");
        const messages = db.collection("messages");

        app.get('/write', async (req, res) => {
            const doc = { message: "Hello from Fatma EKS + SSM", timestamp: new Date() };
            await messages.insertOne(doc);
            res.send("Message saved to MongoDB via SSM!");
        });

        app.get('/', (req, res) => {
            res.sendFile(path.join(__dirname, 'public', 'index.html'));
        });

        app.listen(8081, () => console.log("Server running on port 8081"));
    } catch (err) {
        console.error("Error connecting to MongoDB:", err);
    }
}

run();
