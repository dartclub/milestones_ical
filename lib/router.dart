import 'dart:io';
import 'package:milestones_ical/generate.dart';

typedef Future<void> Route(HttpRequest request);

Future<void> onNotFound(HttpRequest request) async {
  request.response
    ..statusCode = 404
    ..write('file not found.')
    ..close();
}

Future<void> onInternalError(HttpRequest request) async {
  request.response
    ..statusCode = 500
    ..write('internal server error')
    ..close();
}

requestHandler(HttpRequest request) async {
  try {
    await generate(request);
  } catch (e) {
    print(e.toString());
    await onInternalError(request);
  }
}
