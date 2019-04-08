import 'package:ical_serializer/ical_serializer.dart';
import 'package:milestones_ical/router.dart';
import 'dart:io';

class PushupCalendar {
  final DateTime startTime;
  final int startCount;
  final raw = <Map>[
    // week 1
    {
      "diff": Duration(days: 1),
      "sets": [
        [2, 3, 2, 2, 3],
        [6, 6, 4, 4, 5],
        [10, 12, 7, 7, 9],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [3, 4, 2, 3, 4],
        [6, 8, 6, 6, 7],
        [10, 12, 8, 8, 12],
      ],
      "rest": Duration(seconds: 90)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [4, 5, 4, 4, 5],
        [8, 10, 7, 7, 10],
        [11, 15, 9, 9, 13],
      ],
      "rest": Duration(seconds: 120)
    },
    // week 2
    {
      "diff": Duration(days: 3),
      "sets": [
        [4, 6, 4, 4, 6],
        [9, 11, 8, 8, 11],
        [14, 14, 10, 10, 15],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [5, 6, 4, 4, 7],
        [10, 12, 9, 9, 13],
        [14, 16, 12, 12, 17],
      ],
      "rest": Duration(seconds: 90)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [5, 7, 5, 5, 8],
        [12, 13, 10, 10, 15],
        [16, 17, 14, 14, 20],
      ],
      "rest": Duration(seconds: 120)
    },
    // week 3
    {
      "diff": Duration(days: 3),
      "sets": [
        [10, 12, 7, 7, 9],
        [12, 17, 13, 13, 17],
        [14, 18, 14, 14, 20],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [10, 12, 8, 8, 12],
        [14, 19, 14, 14, 19],
        [20, 25, 15, 15, 25],
      ],
      "rest": Duration(seconds: 90)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [11, 13, 9, 9, 13],
        [16, 21, 15, 15, 21],
        [22, 30, 20, 20, 28],
      ],
      "rest": Duration(seconds: 120)
    },
    // week 4
    {
      "diff": Duration(days: 3),
      "sets": [
        [12, 14, 11, 10, 16],
        [18, 22, 16, 16, 25],
        [21, 25, 21, 21, 32],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [14, 16, 12, 12, 18],
        [20, 25, 20, 20, 28],
        [25, 29, 25, 25, 36],
      ],
      "rest": Duration(seconds: 90)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [16, 18, 13, 13, 20],
        [23, 28, 23, 23, 33],
        [29, 33, 29, 29, 40],
      ],
      "rest": Duration(seconds: 120)
    },
    // week 5
    {
      "diff": Duration(days: 3),
      "sets": [
        [17, 19, 15, 15, 20],
        [28, 35, 25, 22, 35],
        [36, 40, 30, 24, 40],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [10, 13, 10, 9, 25],
        [18, 20, 14, 16, 40],
        [19, 22, 18, 22, 45],
      ],
      "rest": Duration(seconds: 45)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [13, 15, 12, 10, 30],
        [18, 20, 17, 20, 45],
        [20, 24, 20, 22, 50],
      ],
      "rest": Duration(seconds: 45)
    },
    // week 6
    {
      "diff": Duration(days: 3),
      "sets": [
        [25, 30, 20, 15, 40],
        [40, 50, 25, 25, 50],
        [45, 55, 35, 30, 55],
      ],
      "rest": Duration(seconds: 60)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [14, 15, 14, 10, 44],
        [20, 23, 20, 18, 53],
        [22, 30, 24, 18, 58],
      ],
      "rest": Duration(seconds: 45)
    },
    {
      "diff": Duration(days: 2),
      "sets": [
        [13, 17, 16, 14, 50],
        [22, 30, 25, 18, 55],
        [26, 33, 26, 22, 60],
      ],
      "rest": Duration(seconds: 45)
    }
  ];
  ICalendar calendar = ICalendar(company: 'ical.ws', product: 'pushups');

  PushupCalendar(String date, String count)
      : startTime = DateTime.parse(date.replaceAll('-', '')),
        startCount = selectPlan(count);

  static selectPlan(String count) {
    int i = int.parse(count);
    if (i <= 5) {
      return 0;
    } else if (i >= 6 && i <= 10) {
      return 1;
    }
    return 2;
  }

  compose() {
    DateTime date = startTime;
    for (var training in raw) {
      date = date.add(training["diff"]);
      String description =
          '${training["rest"].inSeconds}s rest time in between the sets.\nSets:\n- ';
      description += training["sets"][startCount].join(' repeats\n- ') + ' minimum repeats';
      String summary = 'Push-Ups: (${raw.indexOf(training)+1}/${raw.length})';

      calendar.addElement(IEvent(
        start: date,
        description: description,
        summary: summary,
      ));
    }

    calendar.addAll([
      IEvent(
        start: date = date.add(Duration(days: 3)),
        summary: 'Push-Ups (GOAL ACHIEVED)',
        description:
            'You have reached your goal. Now take the test. Do the 100 push-ups',
      ),
      IEvent(
        start: date = date.add(Duration(days: 2)),
        summary: 'Push-Ups (keep up)',
        description: 'Continue with your push-up workout',
        rrule:
            IRecurrenceRule(weekday: 5, frequency: IRecurrenceFrequency.WEEKLY),
      ),
      IEvent(
        start: date = date.add(Duration(days: 2)),
        summary: 'Push-Ups (keep up)',
        description: 'Continue with your push-up workout',
        rrule:
            IRecurrenceRule(weekday: 7, frequency: IRecurrenceFrequency.WEEKLY),
      ),
      IEvent(
        start: date = date.add(Duration(days: 3)),
        summary: 'Push-Ups (keep up)',
        description: 'Continue with your push-up workout',
        rrule:
            IRecurrenceRule(weekday: 3, frequency: IRecurrenceFrequency.WEEKLY),
      ),
    ]);
  }

  String serialize() => calendar.serialize();
}

Future<void> pushupsHandler(HttpRequest request) async {
  List<String> parameters = request.requestedUri.path.substring(1).split('/');
  if (parameters.length == 3) {
    PushupCalendar cal = PushupCalendar(parameters[1], parameters[2]);
    cal.compose();
    request.response
      ..headers.contentType = ContentType('text', 'calendar')
      ..write(cal.serialize())
      ..close();
  } else {
    await onNotFound(request);
  }
}
