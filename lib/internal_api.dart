import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router generateInternalApi() {
  final app = Router();
  app.post('/offer', (Request request) async {
    final body = await request
        .readAsString()
        .then((v) => jsonDecode(v) as Map<String, dynamic>);
    return Response.notFound(body);
  });
  return app;
}
