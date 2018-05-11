import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:watoplan/data/models.dart';

class LoadDefaults {

  static const String codepointsFile = 'assets/defaults/codepoints';
  static List<int> codepoints = [];
  static List<IconData> icons = [];

  static const String dataFile = 'assets/defaults/data.json';

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
    print('ehy');
    return rootBundle.loadString(dataFile)
      .then((contents) => [[], []]);
    //   .then((parsed) {
    //     // if (parsed is! Map || !parsed.containsKey('activityTypes') || parsed['activityTypes'] is! List) return onError();

    //     List activityTypes = []; //parsed['activityTypes'].map((type) => new ActivityType.fromJson(type)).toList();
    //     List<Activity> activities = []; //parsed.containsKey('activities') && parsed['activities'] is List
          // ? parsed['activities'].map((activity) => new Activity.fromJson(activity, activityTypes)).toList()
          // : [];

      // });
  }



}
