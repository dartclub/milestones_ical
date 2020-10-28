import 'dart:io';
import 'package:milestones_ical/milestones.dart';
import 'package:milestones_ical/pushups.dart';

typedef Future<void> Route(HttpRequest request);
final Map<String, Route> routes = {
  '/': (HttpRequest request) async {
    request.response
      ..write('''
try:
\tMilestones for a public github repository
\t\t/milestones/:owner/:repo.ics

\t100 Push-ups calendar feed
\t\t/pushups/:date/:number
\t\t you have to start with an evaluation test to see how many push-ups you can do
\t\t the first argument ist the date of your test, formatted like this: YYYY-MM-DD.
\t\t the second argument is the number of push-ups you can do.
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
