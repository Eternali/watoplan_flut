import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'package:watoplan/key_strings.dart';

void main() {
  group('create todo test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver?.close();
    });

    test('tap todo', () async {
      Timeline timeline = await driver.traceAction(() async {
        await driver.tap(find.byValueKey(KeyStrings.createFam));
        await driver.tap(find.byValueKey(KeyStrings.subFabs(KeyStrings.createFam, 0)));
      });

      TimelineSummary summary = TimelineSummary.summarize(timeline);
      summary.writeSummaryToFile('tap_todo_performance', pretty: true);
      summary.writeTimelineToFile('tap_todo_performance', pretty: true);      
    });

  });
}
