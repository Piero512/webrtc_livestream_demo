import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCChannel {
  static final defaultConfiguration = <String, dynamic>{
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  final RTCPeerConnection peer;

  RTCChannel._(this.peer);

  static Future<RTCChannel> createWithDefaults() async {
    final _conn = await createPeerConnection(defaultConfiguration);
    return RTCChannel._(_conn);
  }
}
