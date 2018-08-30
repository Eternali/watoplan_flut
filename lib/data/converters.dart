import 'dart:convert' show json;

import 'package:flutter/material.dart';
// import 'package:contact_finder/contact_finder.dart';

import 'package:watoplan/data/location.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/models.dart';

class Converters {

  // NOTE: icon code points and color hex values are all hexidecimal integers,
  // I'm just saving them as strings for database storage independent safety

  static IconData iconFromString(String iconStr) {
    // generates icondata from a unicode (hex) representation.
    return IconData(int.parse(iconStr), fontFamily: 'MaterialIcons');
  }

  static String iconToString(IconData icon) {
    // extracts the unicode representation of the icon and makes it a valid hex code.
    return icon.toString().split(new RegExp(r'[()]'))[1].replaceFirst('U+', '0x');
  }

  static Color colorFromString(String colorStr) {
    return Color(int.parse(colorStr));
  }

  static String colorToString(Color color) {
    return color.toString().split(new RegExp(r'[()]'))[1];
  }

  static DateTime dateTimeFromString(String millis) {
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(int.tryParse(millis));
  }

  static String dateTimeToString(DateTime datetime) {
    return datetime == null ? null : datetime.millisecondsSinceEpoch.toString();
  }

  static dynamic paramsFromJson(dynamic params, [ bool getAllData = false ]) {
    return params is List
      ? params.cast<String>()
      : params is Map
        ? getAllData
          ? params.map<String, dynamic>((k, v) => MapEntry(k, validParams[k]?.fromJson(v)))
          : params.keys.toList()
        : throw Exception('Invalid JSON map passed, must be either a List<String> or Map<String, dynamic>');
  }

  static dynamic paramsToJson(dynamic params, [ bool saveAllData = false ]) {
    return params is List
      ? params.cast<String>()
      : params is Map
        ? saveAllData
          ? params.map<String, dynamic>((k, v) => MapEntry(k, validParams[k]?.toJson(v)))
          : params.keys.toList()
        : throw Exception('Invalid parameters passed, must be either a List<String> or Map<String, dynamic>.');
  }

}