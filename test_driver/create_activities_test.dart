import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'package:watoplan/key_strings.dart';

void main() {
  // SystemChannels.platform.setMockMethodCallHandler((MethodCall methodCall) async {
  //   print(methodCall.method);
  //   return Future.value(null);
  // });

  group('create activity test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver?.close();
    });

    test('launch add screen', () async {
      Timeline timeline = await driver.traceAction(() async {
        await driver.tap(find.byValueKey(KeyStrings.createFam), timeout: Duration(seconds: 10));
        // await driver.tap(find.byValueKey(KeyStrings.subFabs(KeyStrings.createFam, 0)));
      });

      TimelineSummary.summarize(timeline)
        ..writeSummaryToFile('launch_add_perf', pretty: true)
        ..writeTimelineToFile('launch_add_perf', pretty: true);      
    });

  });

  // SystemChannels.platform.setMockMethodCallHandler(null);
}
