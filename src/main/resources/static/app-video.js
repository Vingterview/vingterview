var stompClient = null;

function videoON(){
    navigator.mediaDevices.getUserMedia(
        {video: true,audio:true})
        .then(function (stream){
            // 카메라 스트림을 비디오 요소에 연결하여 화면에 표시
            var video = document.getElementById('video');
            video.srcObject = stream
            console.log(stream);
        })
}


function subscribeVideo() {
    stompClient.subscribe('/topic/video', function (byteArray) {
        console.log(byteArray)
        var blob = new Blob([byteArray], { type: 'video/webm' });
        showVideo(blob);
    });
}

function sendVideo() {
    var videoElement = document.getElementById('video');
    var stream = videoElement.srcObject;

    var videoTrack = stream.getVideoTracks()[0];
    var mediaRecorder = new MediaRecorder(videoTrack);


    mediaRecorder.ondataavailable = function(event) {
        console.log(event)
        if (event.data && event.data.size > 0) {
            // 데이터를 Blob으로 변환하여 WebSocket으로 전송
            var blobData = new Blob([event.data], { type: 'video/webm' });
            stompClient.send("/app/stream",{},blobData);
        }
    };
    mediaRecorder.start(1000);
    // stompClient.send("/app/stream", {}, stream.getVideoTracks());

}

function showVideo(stream) {
    // $("#videos").append("<tr><td>" + "<video autoplay></video>"+ "</td></tr>");
    // console.log(video)
    var videoElement = document.getElementById("receivedVideo");
    videoElement.srcObject = stream;
}

$(function () {

    $("#subscribeVideo").click(function () {
        subscribeVideo();
    });
    $("#videoOn").click(function () {
        videoON();
    });
    $("#sendVideo").click(function () {
        sendVideo();
    });


});


