import 'dart:async';
import 'dart:convert';
import 'dart:io';

class StreamingServerManager {
  final HttpServer server;
  final List<WebSocket> peers = [];
  late final StreamSubscription newClientsSub;
  final Map<WebSocket, StreamSubscription> peerSubs = {};
  // final StreamController<RTCIceCandidate> peerStreams;
  int get port => server.port;

  StreamingServerManager._(this.server) {
    final wsTransform = WebSocketTransformer();
    newClientsSub = server.transform(wsTransform).listen((newPeer) {
      peers.add(newPeer);
      peerSubs[newPeer] = newPeer.listen((message) {
        if (message is String) {
          final decoded = jsonDecode(message);
          // TODO: Receive the offers and shit.
        } else {
          newPeer.close(
            WebSocketStatus.unsupportedData,
            'This Websocket server uses a JSON based protocol!',
          );
          peerSubs.remove(newPeer)?.cancel();
        }
      });
    });
  }

  static Future<StreamingServerManager> createNewConnection() async {
    final server =
        await HttpServer.bind(InternetAddress.anyIPv6, 0, backlog: 10);
    return StreamingServerManager._(server);
  }

  dispose() {
    server.close();
  }
}
