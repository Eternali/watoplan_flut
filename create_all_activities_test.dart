import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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
      await driver.tap(find.byValueKey('create-fam'));
      await driver.tap(find.byValueKey('create-fam-1'));
      
    });

  });
}
