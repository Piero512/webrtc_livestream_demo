import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key}) : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  Future<void> initializeRenderers() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
    _getUserMedia();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    setState(() {
      _localVideoRenderer.srcObject = stream;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _localVideoRenderer.srcObject?.dispose();
    await _localVideoRenderer.dispose();
    await _remoteVideoRenderer.srcObject?.dispose();
    await _remoteVideoRenderer.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeRenderers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example WebRTC'),
      ),
      body: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                const Text("Local Video is shown down here"),
                Expanded(
                  child: RTCVideoView(
                    _localVideoRenderer,
                    filterQuality: FilterQuality.high,
                    mirror: true,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: [
                const Text("Remote video is shown here"),
                Expanded(
                  child: RTCVideoView(
                    _remoteVideoRenderer,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
