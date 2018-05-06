import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadDefaults {

  static const String codepointsFile = 'assets/defaults/codepoints';
  static List<int> codepoints = [];
  static List<IconData> icons = [];

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


}
