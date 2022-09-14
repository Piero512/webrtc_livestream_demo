import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart' as io;
import 'package:web_socket_channel/status.dart' as status;

class StreamingClient {
  final io.WebSocketChannel _channel;
  final _peerController = StreamController<RTCIceCandidate>();

  StreamingClient(this._channel) {
    _channel.stream.listen((event) {
      if (event is String) {
        final decoded = jsonDecode(event);
      } else {
        _channel.sink.close(
          status.unsupportedData,
          'This WebSocket server uses a JSON based protocol!',
        );
      }
    });
  }
}
