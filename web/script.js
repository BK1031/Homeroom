

var localStream = null;
var localStreamDiv = null;

let handleFail = function(err){
    console.log("Error : ", err);
};

let remoteContainer = document.getElementById("remote-container");
let cameraToggleBtn = document.getElementById("camera-toggle");
let micToggleBtn = document.getElementById("mic-toggle");

//------------------------------------------------------------------------------------------------------------------------


// default room and default user id

var options = {
    appId: '0635469ee0d748a28432cfe30e80507c',
    channel: 'room1',
    token: '0060635469ee0d748a28432cfe30e80507cIAD5RJh3wPsJK8/BQCWiYeGM4n5z5490yoDERtQ7ObgXMSo6c+QAAAAAEAAzuiAF3wtnXwEAAQDfC2df',
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
    options.uid = parseInt(urlHash.split('#')[1]);
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
            db.ref('rooms/'+options.channel+'/users/'+streamId).set({
                x: 0,
                y: 0,
            });
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
    //modifyAudio(streamId);
    updatePositionListener(streamId);
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

cameraToggleBtn.addEventListener("click",()=>{
    if(localStream.isVideoOn()) {
        localStream.muteVideo();
    } else {
        localStream.unmuteVideo();
    }
});

micToggleBtn.addEventListener("click",()=>{
    if(localStream.isAudioOn()){
        localStream.muteAudio();
    } else {
        localStream.unmuteAudio();
    }
});

//---------------------------------------------------------------------------------------------

// delete from firebase when exiting window; exit should be checked in server
window.onunload = function() {
    client.leave(function(){
        localStream.stop();
        localStream.close();
        db.ref('rooms/'+options.channel+'/users').child(String(localStream.getId())).remove();
    }, handleFail);
};

var tempDiv = null;
function updatePositionListener(id) {
    db.ref('rooms/'+options.channel+'/users/'+id).on(
        'value', function(snapshot){
            let data = snapshot.val();
            tempDiv = document.getElementById(id);
            tempDiv.style.left = data.x+'px';
            tempDiv.style.top = data.y+'px';
        }
    )
}

//---------------------------------------------------------------------------------------------

// let unitSize = 40;
// var difX, difY;

localStreamDiv = addStream('my-stream');
localStreamDiv.setAttribute('draggable','false');
// localStreamDiv.addEventListener("dragstart", function(ev){
//     difX = ev.clientX - localStreamDiv.getBoundingClientRect().left;
//     difY = ev.clientY - localStreamDiv.getBoundingClientRect().top;
// });
// remoteContainer.addEventListener("dragover", function(ev){
//     ev.preventDefault();
// });
// remoteContainer.addEventListener("drop", function(ev){
//     ev.preventDefault();
//     var newX = ev.clientX - difX - remoteContainer.getBoundingClientRect().left;
//     var newY = ev.clientY - difY - remoteContainer.getBoundingClientRect().top;
//     newX = Math.round(newX/unitSize)*unitSize;
//     newY = Math.round(newY/unitSize)*unitSize;
//     localStreamDiv.style.left = newX+'px';
//     localStreamDiv.style.top = newY+'px';
//     db.ref('rooms/'+options.channel).child(String(localStream.getId())).update({
//         x: newX, y: newY,
//     });
// });
