import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../providers/videos_api.dart';
import '../providers/uploadmp4.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordVideoPage extends StatefulWidget {
  final String buttonText;
  RecordVideoPage({@required this.buttonText});

  @override
  _RecordVideoPageState createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  // Define a variable for the camera controller.
  CameraController _controller;

  // Define a variable for the file that stores the recorded video.
  File _videoFile;
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  String videoUrl;
  bool isLoading = false;
  String question;
  String _buttonText;

  // Define a method to initialize the camera.
  Future<void> initCamera() async {
    // Get a list of available cameras.
    List<CameraDescription> cameras = await availableCameras();

    // Choose the front camera.
    CameraDescription frontCamera;
    for (CameraDescription camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      // Initialize the camera controller with the front camera.
      _controller = CameraController(frontCamera, ResolutionPreset.high);
    } else {
      // If no front camera is available, initialize the camera controller with the first camera in the list.
      _controller = CameraController(cameras[0], ResolutionPreset.high);
    }

    // Initialize the camera.
    await _controller.initialize();

    // Initialize the video file.
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    _videoFile = File('${directory.path}/video.mp4');
  }

  // Define a method to start recording a video.
  Future<void> startRecording() async {
    // Start recording a video.
    final directory = await getApplicationDocumentsDirectory();
    _videoFile = File('${directory.path}/video.mp4');
    await _controller.startVideoRecording();
  }

  // Define a method to stop recording a video.
  Future<void> stopRecording() async {
    setState(() {
      isLoading = true;
    });
    // Stop recording a video.
    final XFile video = await _controller.stopVideoRecording();
    final directory = await getApplicationDocumentsDirectory();
    _videoFile = File('${directory.path}/video.mp4');
    // print('path is ${video.path}');
    // print(_videoFile.path);

    final bool exists = await _videoFile.exists();

    videoUrl = await uploadVideoApi.uploadVideo(video);
    print(videoUrl);

    // Pop the page and return the video URL.
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, videoUrl);
  }

  // Define a method to handle the on-screen buttons.
  void handleButton(int buttonIndex) async {
    switch (buttonIndex) {
      case 0: // Start recording a video.
        await startRecording();
        break;
      case 1: // Stop recording a video.
        await stopRecording();
        break;
    }
  }

  @override
  void initState() {
    _buttonText = widget.buttonText;
    super.initState();
    initCamera().then((_) {
      // initCamera()가 완료될 때까지 기다린 후에 build() 메서드를 호출함
      setState(() {}); // 화면을 다시 그리기 위해 setState()를 호출함
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 화면 전체에 배치되도록 설정
      body: Stack(
        children: [
          Visibility(
            visible: _controller?.value?.isInitialized ?? false,
            child: Center(
              child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _buttonText,
                    style: TextStyle(
                      fontSize: 16, // 줄글 글씨 크기
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    'assets/face1.png',
                    width: 500,
                    height: 500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.video_camera_front),
                      onPressed: () => handleButton(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () => handleButton(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
