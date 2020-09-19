var options = {
    appId: '0635469ee0d748a28432cfe30e80507c',
    channel: 'toast',
    token: '0060635469ee0d748a28432cfe30e80507cIACq6vho2crQ95raRWN9rGQawM+VIjlTOCtW1FAQlk/AMEBoWrMAAAAAEAA8pA8oeatlXwEAAQB4q2Vf',
    uid: null,
}

var localStream = null;

let handleFail = function(err){
    console.log("Error : ", err);
};

let remoteContainer = document.getElementById("remote-container");
let cameraToggleBtn = document.getElementById("camera-toggle");
let micToggleBtn = document.getElementById("mic-toggle");

//---------------------------------------------------------------------------------------------

function addStream(elementId){
    let streamDiv = document.createElement("div");
    streamDiv.id = elementId;
    streamDiv.style.transform="rotateY(180deg)";
    remoteContainer.appendChild(streamDiv);
}

function removeStream(elementId) {
    let streamDiv = document.getElementById(elementId);
    if(streamDiv) streamDiv.parentNode.removeChild(streamDiv);
}

/*
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
*/

//---------------------------------------------------------------------------------------------

let client = AgoraRTC.createClient({
    mode: 'rtc',
    codec: 'vp8',
});

client.init(options.appId, handleFail);

client.join(options.token, options.channel, options.uid, (uid)=>{
    localStream = AgoraRTC.createStream({
        video: true,
        audio: true,
    });
    localStream.init(()=>{
        localStream.play('my-feed');
        client.publish(localStream, handleFail);
    }, handleFail);
}, handleFail);

client.on('stream-added', function(evt){
    client.subscribe(evt.stream, handleFail);
});

client.on('stream-subscribed', function(evt){
    let stream = evt.stream;
    let streamId = String(stream.getId());
    addStream(streamId);
    stream.play(streamId);
    modifyAudio(streamId);
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
