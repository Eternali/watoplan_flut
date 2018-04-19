import 'dart:convert' show json;

import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

class Converters {

  // NOTE: icon code points and color hex values are all hexidecimal integers,
  // I'm just saving them as strings for database storage independent safety

  static IconData iconFromString(String iconStr) {
    // generates icondata from a unicode (hex) representation.
    return new IconData(int.parse(iconStr), fontFamily: 'MaterialIcons');
  }

  static String iconToString(IconData icon) {
    // extracts the unicode representation of the icon and makes it a valid hex code.
    return icon.toString().split(new RegExp(r'[()]'))[1].replaceFirst('U+', '0x');
  }

  static Color colorFromString(String colorStr) {
    return new Color(int.parse(colorStr));
  }

  static String colorToString(Color color) {
    return color.toString().split(new RegExp(r'[()]'))[1];
  }

  static DateTime dateTimeFromString(String millis) {
    return new DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
  }

  static String dateTimeToString(DateTime datetime) {
    return datetime.millisecondsSinceEpoch.toString();
  }

  static Map<String, dynamic> paramsFromJson(Map<String, dynamic> params) {
    // NOTE: technically params is an already decoded json string,
    // we're just decoding complex objects that have been encoded in strings.
    return params.map((k, v) {
      switch (k) {
        case 'datetime':
          return new MapEntry(k, dateTimeFromString(v));
          break;
        case 'location':
          return new MapEntry(k, v.toString());
          break;
        default:
          if (VALID_PARAMS.containsKey(k))
            return new MapEntry(k, v);
          else
            throw new Exception('$k is not a valid parameter');
          break;
      }
    });
  }

  static String paramsToJson(Map<String, dynamic> params) {
    return json.encode(params.map((k, v) {
      switch (k) {
        case 'datetime':
          return new MapEntry(k, dateTimeToString(v));
          break;
        case 'location':
          return new MapEntry(k, v.toString());
          break;
        default:
          if (VALID_PARAMS.containsKey(k))
            return new MapEntry(k, v);
          else
            throw new Exception('$k is not a valid parameter');
          break;
      }
    }));
  }

}