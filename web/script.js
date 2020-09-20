

var localStream = null;
var localStreamDiv = null;
var screenStream = null;
var screenStreamDiv = null;

var userPos = [0,0];
var otherPos = {}; // dictionary of objects id:{x, y, stream}
// volume is 0 to 100, computed based on user's distance from other user

let handleFail = function(err){
    console.log("Error : ", err);
};

let remoteContainer = document.getElementById("remote-container");

//------------------------------------------------------------------------------------------------------------------------


// DONT USE default room and default user id

var options = {
    appId: '0635469ee0d748a28432cfe30e80507c',
    channel: 'codin',
    token: "0060635469ee0d748a28432cfe30e80507cIABcTGhRTJsNL3AKUWXdQAzrOCj2m8v5fXfdAblxVAzfkpjiHioAAAAAIgBWJtrxBGJoXwQAAQCUHmdfAgCUHmdfAwCUHmdfBACUHmdf",
    uid: null,
}


let client = AgoraRTC.createClient({
    mode: 'rtc',
    codec: 'vp8',
});

client.init(options.appId, handleFail);


function createNewChannel(channel){
    db.ref('rooms/'+channel).once('value', async function(snapshot){
        if(snapshot.exists()){
            let data = snapshot.val();
            options.channel = channel;
            options.token = data.token;
            joinChannel();
        } else {
            db.ref('rooms/'+channel).set('hi');
            db.ref('rooms/'+channel+'/token').on('value', function(snapshot){
                let data = snapshot.val();
                if(data != null) {
                    options.channel = channel;
                    options.token = data;
                    joinChannel();
                }
            });
        }
    });
}


var urlHash = window.location.hash;
if(urlHash){
    options.uid = urlHash.split('#')[1];
    let channel = urlHash.split('#')[2];
    if(channel != null){
        createNewChannel(channel);
    } else {
        joinChannel();
    }
} else {
    joinChannel();
}




//---------------------------------------------------------------------------------------------

function addStream(elementId){
    let streamDiv = document.createElement("div");
    streamDiv.id = elementId;
    streamDiv.style.transform="rotateY(180deg)";
    streamDiv.classList.add('stream-div');
    remoteContainer.appendChild(streamDiv);
    return streamDiv;
}

function removeStream(elementId) {
    let streamDiv = document.getElementById(elementId);
    if(streamDiv) streamDiv.parentNode.removeChild(streamDiv);
}

// this is the audio panner but isn't working right now

function modifyAudio(id) {
    console.log(id);
    let audioElement = document.getElementById("audio"+id);
    //let audioElement = document.querySelectorAll("audio")[1];
    var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    var source = audioCtx.createMediaElementSource(audioElement);
    var panNode = audioCtx.createStereoPanner();
    panNode.pan.value = -1;
    source.connect(panNode);
    panNode.connect(audioCtx.destination);
}



//---------------------------------------------------------------------------------------------


function joinChannel() {
    client.join(options.token, options.channel, options.uid, (uid)=>{
        localStream = AgoraRTC.createStream({
            video: true,
            audio: true,
        });
        localStream.init(()=>{
            client.publish(localStream, handleFail);
            let streamId = String(localStream.getId());
            addMuteUnmuteListeners();
            localStream.play('my-stream');
            localStream.play(streamId);
        });
    }, handleFail);
}

client.on('stream-added', function(evt){
    client.subscribe(evt.stream, handleFail);
});

client.on('stream-subscribed', function(evt){
    let stream = evt.stream;
    let streamId = String(stream.getId());
    addStream(streamId);
    stream.play(streamId);
    // stream.setAudioVolume(5);
    otherPos[streamId] = {
        stream: stream,
        x: 0,
        y: 0,
    };
    //modifyAudio(streamId);
});

client.on('stream-removed', function(evt){
    let stream = evt.stream;
    let streamId = String(stream.getId());
    stream.close();
    removeStream(streamId);
});

client.on('peer-leave', function(evt){
    let stream = evt.stream;
    let streamId = String(stream.getId());
    stream.close();
    removeStream(streamId);
});

//---------------------------------------------------------------------------------------------


function computeVolume(otherUser) {
    let deltaX = otherUser.x - userPos[0];
    let deltaY = otherUser.y - userPos[1];
    let dist = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
    var volume = 100.0-dist/10.0;
    volume = Math.max(volume, 0);
    otherUser.stream.setAudioVolume(volume);
}


function addMuteUnmuteListeners() {
    db.ref('rooms/'+options.channel+'/users/'+options.uid+'/audio').on('value', function(snapshot){
        if (snapshot.val()==null || snapshot.val()) {
            localStream.unmuteAudio();
        }
        else {
            localStream.muteAudio();
        }
    });

    db.ref('rooms/'+options.channel+'/users/'+options.uid+'/video').on('value', function(snapshot){
        if (snapshot.val()==null || snapshot.val()) {
            localStream.unmuteVideo();
        }
        else {
            localStream.muteVideo();
        }
    });

    db.ref('rooms/'+options.channel+'/users/').on('child_added', function(userSnapshot){
        alert('child!');
        if(userSnapshot.key == options.uid){ // is user
            db.ref('rooms/'+options.channel+'/users/'+userSnapshot.key).on('value', function(snapshot){
                let data = snapshot.val();
                if (data!=null) {
                    userPos[0] = data.x;
                    userPos[1] = data.y;
                    for(id in Object.keys(otherPos)){
                        computeVolume(otherPos[id]);
                    }
                }
            });
        } else {
            db.ref('rooms/'+options.channel+'/users/'+userSnapshot.key).on('value', function(snapshot){
                let data = snapshot.val();
                if (data!=null) {
                    otherPos[userSnapshot.key].x = data.x;
                    otherPos[userSnapshot.key].y = data.y;
                    computeVolume(otherPos[userSnapshot.key]);
                }
            });
        }
        
    });

}


//---------------------------------------------------------------------------------------------

// delete from firebase when exiting window; exit should be checked in server
window.onunload = function() {
    client.leave(function(){
        localStream.stop();
        localStream.close();
        db.ref('rooms/'+options.channel+'/users').child(String(localStream.getId())).remove();
    }, handleFail);
};


//---------------------------------------------------------------------------------------------


localStreamDiv = addStream('my-stream');
