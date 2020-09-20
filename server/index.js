var admin = require('firebase-admin');
const express = require('express')

const app = express()
const port = 7000

var serviceAccount = require("./serviceAccountKey.json");

app.use(express.static('web'))

app.listen(port, () => console.log(`Server listening at http://localhost:${port}`))

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://homeroom-app.firebaseio.com"
});

var db = admin.database().ref();

db.child("rooms").on("child_added", function(snapshot, prevChildKey) {
    // New room was created
    console.log(snapshot.key);
    var room = snapshot.val();
});