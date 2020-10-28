import 'package:ical/serializer.dart';
import 'package:milestones_ical/router.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> milestonesHandler(HttpRequest request) async {
  List<String> parameters = request.uri.pathSegments;

  if (parameters.length == 3) {
    var user = parameters[1];
    var repo = parameters.last.endsWith('.ics')
        ? parameters.last.substring(0, parameters.last.length - 4)
        : parameters.last;

    var url = 'https://api.github.com/repos/$user/$repo/milestones';
    var milestones = await http.get(url);
    if (milestones.statusCode == 200) {
      var jsonMilestones = json.decode(milestones.body);
      ICalendar iCalendar =
          ICalendar(product: parameters.last, company: parameters.first);
      for (var milestone in jsonMilestones) {
        DateTime start = DateTime.parse(milestone['closed_at'] ??
            milestone['due_on'] ??
            milestone['updated_at']);
        String title =
            '${milestone['title']} [${milestone['state'].toString().toUpperCase()}]';
        String comment =
            'Issues: ${milestone['open_issues']} open / ${milestone['closed_issues']} closed.';
        iCalendar.addElement(
          IEvent(
            start: start,
            description: milestone['description'].toString(),
            comment: comment,
            summary: title,
            status: IEventStatus.CONFIRMED,
            classification: IClass.PUBLIC,
            uid: milestone['id'].toString(),
            url: milestone['html_url'].toString(),
            transparency: ITimeTransparency.TRANSPARENT,
          ),
        );
      }
      request.response
        ..headers.contentType = ContentType('text', 'calendar')
        ..write(iCalendar.serialize())
        ..close();
    } else {
      await onNotFound(request);
    }
  }
}
