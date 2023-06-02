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
  Color iconColor = Colors.white;

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

    // Pop the page and return the video URL.
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, video);
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
      setCameraPreviewSize();
    });
  }

// 카메라 프리뷰의 크기를 설정하는 메서드
  void setCameraPreviewSize() {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }

    // 카메라 프리뷰의 크기와 디바이스의 크기를 비교하여 가로-세로 비율을 조정
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double previewWidth = _controller.value.previewSize.width;
    final double previewHeight = _controller.value.previewSize.height;

    final double deviceAspectRatio = deviceWidth / deviceHeight;
    final double previewAspectRatio = previewWidth / previewHeight;

    // 디바이스의 가로-세로 비율과 카메라 프리뷰의 가로-세로 비율을 비교하여 스케일 적용
    double scale = 1.0;
    if (deviceAspectRatio > previewAspectRatio) {
      scale = deviceAspectRatio / previewAspectRatio;
    } else {
      scale = previewAspectRatio / deviceAspectRatio;
    }

    // 카메라 프리뷰의 크기 조정
    setState(() {
      _controller.value = _controller.value.copyWith(
        previewSize: Size(previewWidth * scale, previewHeight * scale),
      );
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
                aspectRatio: MediaQuery.of(context).size.aspectRatio * 1.12,
                child: CameraPreview(_controller),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height *
                0.88, // 위쪽 검정색 박스의 높이 설정 (30%)
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.85, // 아래쪽 검정색 박스의 위치 설정 (70%)
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              bottom: 0,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Q. $_buttonText",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ])),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.23,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(children: [
                Image.asset(
                  'assets/face_line.png',
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.65,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.video_camera_front,
                        color: iconColor, // 아이콘 색상 설정
                      ),
                      onPressed: () {
                        setState(() {
                          iconColor = Colors.red; // 버튼을 눌렀을 때 아이콘 색상 변경
                        });
                        handleButton(0);
                      },
                      iconSize: 32,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.stop,
                        color: Colors.white,
                      ),
                      onPressed: () => handleButton(1),
                      iconSize: 32,
                    ),
                  ],
                ),
              ]))
        ],
      ),
    );
  }
}
