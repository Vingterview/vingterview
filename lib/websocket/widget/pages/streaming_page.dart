import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:capston/websocket/wsclient/stage.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:capston/authpack.dart' as authpack;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:provider/provider.dart';

import '../../wsclient/game_state.dart';

const String appId = "900e3c6f550048e98c348640f5febd90";

class StreamingPage extends StatefulWidget {
  StreamingPage(
      {Key key,
      @required this.token,
      @required this.channelName,
      @required this.currentBroadcaster,
      @required this.isHost,
      @required this.onStart,
      @required this.onFinished})
      : super(key: key);

  String token;
  String channelName;
  String currentBroadcaster;
  bool isHost; // Indicates whether the user has joined as a host or audience
  WebSocketClient client;
  final void Function() onStart;
  final void Function() onFinished;

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  int uid = 0; // uid of the local user

  int _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool _onAir = false;
  RtcEngine agoraEngine; // Agora engine instance

  Stage _stage;

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container for the local video
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.48,
          decoration: BoxDecoration(
            border: Border.all(),

            // borderRadius: BorderRadius.circular(10), // 원하는 값으로 설정
            color: Colors.black54, // 원하는 색상으로 설정
          ),
          child: Center(
            child: _videoPanel(),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Visibility(
          visible: widget.isHost,
          child: ElevatedButton(
            onPressed: handleBroadcasting,
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.blue.withOpacity(0.2)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xFF8A61D4),
                  ),
                ),
              ),
              elevation: MaterialStateProperty.all<double>(5.0),
              padding:
              MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15.0)),
            ),
            child: Text(
              _onAir ? '끝내기' : '시작하기',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _videoPanel() {
    if (!_isJoined) {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    } else if (widget.isHost) {
      // Show local video preview
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      // Show remote video
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: widget.channelName),
            // connection: RtcConnection(channelId: "testChannel"),
          ),
        );
      } else {
        // 방송시작 안했을때
        return Container(
          margin: EdgeInsets.only(bottom: 8.0),
          child: Text(
            '참가자가 준비될 때까지 잠시만 기다려주세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
  }

  // Widget _videoPanel() {
  //   if(_stage == Stage.WATCH_STREAMING) {
  //     join();
  //   } else if (_stage == Stage.FINISH_STREAMING) {
  //     _leaveChannel();
  //   }
  //
  //   if (widget.isHost) {
  //     join();
  //
  //     return ValueListenableBuilder(
  //         valueListenable: _onAir,
  //         builder: (context, onAir, child) {
  //           if (onAir) {
  //             // Show local video preview
  //             return AgoraVideoView(
  //               controller: VideoViewController(
  //                 rtcEngine: agoraEngine,
  //                 canvas: VideoCanvas(uid: 0),
  //               ),
  //             );
  //           } else {
  //             return SizedBox();
  //           }
  //         });
  //   } else {
  //     // if (!_isJoined) {
  //     //   join();
  //     // }
  //     // Show remote video
  //     if (_remoteUid != null) {
  //       return AgoraVideoView(
  //         controller: VideoViewController.remote(
  //           rtcEngine: agoraEngine,
  //           canvas: VideoCanvas(uid: _remoteUid),
  //           connection: RtcConnection(channelId: widget.channelName),
  //         ),
  //       );
  //     } else {
  //       // 방송시작 안했을때
  //       // return const Text("참가자가 준비될 때까지 잠시만 기다려주세요!");
  //       return Container(
  //         margin: EdgeInsets.only(bottom: 8.0),
  //         child: Text(
  //           '참가자가 준비될 때까지 잠시만 기다려주세요!',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }


  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: appId
    ));

    if (Platform.isAndroid) {
      print("[isAndroid]");
      //TODO path부분 바꿔가면서 라이브러리 로드할수있게 찾기
      await agoraEngine.loadExtensionProvider(path: '/libs/extension_aar-release.aar');
    }

    await agoraEngine.enableExtension(
        provider: "FaceUnity", extension: "Effect", enable: true);


    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
        onExtensionStarted: (provider, extension) {
          debugPrint(
              '[onExtensionStarted] provider: $provider, extension: $extension');
          if (provider == 'FaceUnity' && extension == 'Effect') {
            initializeFaceUnityExt();
          }
        },
        onExtensionError: (provider, extension, error, message) {
          debugPrint(
              '[onExtensionError] provider: $provider, '
                  'extension: $extension, error: $error, message: $message');
        },
        onExtensionEvent: (String provider, String extName, String key, String value) {
          debugPrint(
              '[onExtensionEvent] provider: $provider, '
                  'extension: $extName, key: $key, value: $value');
        },
        onError: (e, msg) {
          print("[에러발생] :$e, $msg");
        },
      ),
    );

    join();
  }


  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();

    await agoraEngine.setExtensionProperty(
        provider: 'FaceUnity',
        extension: 'Effect',
        key: 'fuDestroyLibData',
        value: jsonEncode({})
    );

    super.dispose();
  }

  Future<void> initializeFaceUnityExt() async {
    // Initialize the extension and authenticate the user
    await agoraEngine.setExtensionProperty(
        provider: 'FaceUnity',
        extension: 'Effect',
        key: 'fuSetup',
        value: jsonEncode({'authdata': authpack.gAuthPackage}));

    // Load the AI model
    final aiFaceProcessorPath =
    await _copyAsset('Resource/model/ai_face_processor.bundle');
    await agoraEngine.setExtensionProperty(
        provider: 'FaceUnity',
        extension: 'Effect',
        key: 'fuLoadAIModelFromPackage',
        value: jsonEncode({'data': aiFaceProcessorPath, 'type': 1 << 8}));

    // Load the qgirl prop
    final itemPath = await _copyAsset('Resource/items/Animoji/qgirl.bundle');

    await agoraEngine.setExtensionProperty(
        provider: 'FaceUnity',
        extension: 'Effect',
        key: 'fuCreateItemFromPackage',
        value: jsonEncode({'data': itemPath}));
  }

  Future<String> _copyAsset(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    Directory appDocDir = await getApplicationDocumentsDirectory();

    final dirname = path.dirname(assetPath);

    Directory dstDir = Directory(path.join(appDocDir.path, dirname));
    if (!(await dstDir.exists())) {
      await dstDir.create(recursive: true);
    }

    String p = path.join(appDocDir.path, path.basename(assetPath));
    final file = File(p);
    if (!(await file.exists())) {
      await file.create();
      await file.writeAsBytes(bytes);
    }

    return file.absolute.path;
  }


  void handleBroadcasting() {
    if(_onAir) {
      leave();
    } else {
      setState(() {
        _onAir = true;
      });
      widget.onStart.call();
    }
  }

  void join() async {
    if (widget.token == null && widget.channelName == null) {
      return;
    }

    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (widget.isHost) {
      print("Broadcast start");
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      print("Watch broadcasting");
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        // Set the latency level
        audienceLatencyLevel:
            AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
      );
    }

    try {
      await agoraEngine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        options: options,
        uid: uid,
      );
    } catch (e) {
      print("[joinChannel] error : $e");
    }

    setState(() {
      _isJoined = true;
    });
  }

  void leave() {
    _leaveChannel();
    widget.onFinished.call();
    setState(() {
      widget.isHost = false;
    });
  }

  void _leaveChannel() {
    setState(() {
      _onAir = false;
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }
}
