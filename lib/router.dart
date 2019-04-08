import 'dart:io';
import 'package:milestones_ical/milestones.dart';
import 'package:milestones_ical/pushups.dart';

typedef Future<void> Route(HttpRequest request);
final Map<String, Route> routes = {
  '/': (HttpRequest request) async {
    request.response
      ..write('''
          try:
          Github repository milestones feed
            /milestones/:owner/:repo
          
          100 Push-ups calendar feed
            /pushups/YYYY-MM-DD/<number of pushups>
        ''')
      ..close();
  },
  '/pushups': pushupsHandler,
  '/milestones': milestonesHandler,
};

Future<void> onNotFound(HttpRequest request) async {
  request.response
    ..statusCode = 404
    ..write('file not found.')
    ..close();
}

Future<void> onInternalError(HttpRequest request) async {
  request.response
    ..statusCode = 500
    ..write('internal server error.')
    ..close();
}

requestHandler(HttpRequest request) async {
  try {
    Route handler = onNotFound;
    for (String path in routes.keys) {
      if (request.requestedUri.path.startsWith(path)) {
        handler = routes[path];
      }
    }
    await handler(request);
  } catch (e) {
    print(e);
    await onInternalError(request);
  }
}
