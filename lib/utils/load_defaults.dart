import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadDefaults {

  static const String codepointsFile = 'assets/defaults/codepoints';
  static List<int> codepoints = [];
  static List<IconData> icons = [];

  static const String dataFile = 'assets/defaults/data.json';
  static Map<String, dynamic> defaultData = {};

  static Future loadIcons() async {
    return rootBundle.loadString(codepointsFile)
      .then((points) {
        for (String point in points.trim().split('\n')) {
          int cp = int.parse(point.trim(), radix: 16);
          codepoints.add(cp);
          icons.add(new IconData(cp, fontFamily: 'MaterialIcons'));
        }
      });
  }

  static Future loadDefaultData() async {
    return rootBundle.loadString(dataFile)
      .then((contents) => json.decode(contents))
      .then((parsed) {
        defaultData = parsed;
      }).catchError((e) {
        debugPrint('An error occurred: ${e.toString()}');
      });
  }

}
