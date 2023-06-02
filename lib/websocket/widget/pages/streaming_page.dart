import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

const String appId = "900e3c6f550048e98c348640f5febd90";

class StreamingPage extends StatefulWidget {
  StreamingPage(
      {Key key,
      @required this.token,
      @required this.channelName,
      @required this.currentBroadcaster,
      @required this.isHost,
      @required this.onFinished})
      : super(key: key);

  String token;
  String channelName;
  String currentBroadcaster;
  bool isHost; // Indicates whether the user has joined as a host or audience
  final void Function() onFinished;

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  int uid = 0; // uid of the local user

  int _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  final ValueNotifier<bool> _onAir = ValueNotifier(false);
  RtcEngine agoraEngine; // Agora engine instance

  // Build UI
  @override
  Widget build(BuildContext context) {
    if (!_onAir.value && widget.isHost && _isJoined) {
      _leaveChannel();
    }

    return Column(
      children: [
        // Container for the local video
        Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(),

            // borderRadius: BorderRadius.circular(10), // 원하는 값으로 설정
            color: Colors.grey[200], // 원하는 색상으로 설정
          ),
          child: Center(
            child: _videoPanel(),
          ),
        ),
        Visibility(
          visible: widget.isHost,
          child: ElevatedButton(
            onPressed: _handleBroadcasting,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
              _onAir.value ? '끝내기' : '시작하기',
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
    if (widget.isHost) {
      print(_isJoined);
      return ValueListenableBuilder(
          valueListenable: _onAir,
          builder: (context, onAir, child) {
            if (onAir) {
              // Show local video preview
              return AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: agoraEngine,
                  canvas: VideoCanvas(uid: 0),
                ),
              );
            } else {
              return SizedBox();
            }
          });
    } else {
      if (!_isJoined) {
        join();
      }
      // Show remote video
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        );
      } else {
        // 방송시작 안했을때
        // return const Text("참가자가 준비될 때까지 잠시만 기다려주세요!");
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              // height: 450,
              // color: Colors.black38,
              child: Text('참가자가 준비될 때까지 잠시만 기다려주세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
          SizedBox(
            height: 20,
          )
        ]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

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
      ),
    );

    if (!widget.isHost) {
      join();
    }
  }

  void _handleBroadcasting() {
    setState(() {
      _onAir.value = !_onAir.value;
    });

    if (_isJoined) {
      leave();
    } else {
      join();
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
      print("error");
    }

    setState(() {});
  }

  void leave() {
    _leaveChannel();
    widget.onFinished.call();
  }

  void _leaveChannel() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  // Release the resources when you leave

}
