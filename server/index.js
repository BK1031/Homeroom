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


// --------------------------------------------------------------------------------

const options = {
    appId: '0635469ee0d748a28432cfe30e80507c',
    certificate: '0bd05f462de94e45bcb615b54f8f6d6d',
}


function generateToken(channel, uid){
	const RtcTokenBuilder = require('./tokenGeneration/RtcTokenBuilder').RtcTokenBuilder;
	const RtcRole = require('./tokenGeneration/RtcTokenBuilder').Role;
	const role = RtcRole.PUBLISHER;

	const expirationTimeInSeconds = 86400*365;
	const currentTimestamp = Math.floor(Date.now() / 1000);

	const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

	// Build token with uid
	const token = RtcTokenBuilder.buildTokenWithUid(options.appId, options.certificate, channel, uid, role, privilegeExpiredTs);
	console.log("Token With Integer Number Uid: " + token);
	return token;
}



db.child("rooms").on("child_added", function(snapshot, prevChildKey) {
    // New room was created
    console.log(snapshot.key);
    let channel = snapshot.key;
    let token = generateToken(channel, 0);
    db.child("rooms/"+channel).update({
    	token: token,
    });
});



