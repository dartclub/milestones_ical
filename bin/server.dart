import 'dart:io';
import 'package:milestones_ical/router.dart';

main() async {
  try {
    await HttpServer.bind(InternetAddress.anyIPv4, 8080)
      ..listen(requestHandler);
    print('running');
  } catch (e) {
    print(e);
  }
}
