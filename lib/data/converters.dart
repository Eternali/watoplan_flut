import 'dart:convert' show json;

import 'package:flutter/material.dart';

import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/person.dart';
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
        case 'start':
        case 'end':
          return new MapEntry(k, dateTimeFromString(v));
          break;
        case 'notis':
          // this is a dumb workaround for type checking
          // List<Noti> x = []; List<Noti> y = <Noti>[]; assert x.runtimeType != y.runtimeType
          List<Noti> value = <Noti>[];
          for (Noti noti in v.map((noti) => new Noti.fromJson(noti)).toList()) value.add(noti);
          return new MapEntry(k, value);
          break;
        case 'entities':
          List<Person> value = <Person>[];
          for (Person person in v.map((entity) => new Person.fromJson(entity)).toList()) value.add(person);
          return new MapEntry(k, value);
          break;
        case 'location':
          return new MapEntry(k, v.toString());
          break;
        default:
          if (validParams.containsKey(k))
            return new MapEntry(k, v);
          else
            throw new Exception('$k is not a valid parameter');
          break;
      }
    });
  }

  static Map<String, dynamic> paramsToJson(Map<String, dynamic> params) {
    return params.map((k, v) {
      switch (k) {
        case 'start':
        case 'end':
          return new MapEntry(k, dateTimeToString(v));
          break;
        case 'notis':
          return new MapEntry(k, v.map((noti) => noti.toJson()).toList());
          break;
        case 'entities':
          return new MapEntry(k, v.map((entity) => entity.toJson()).toList() as List<Person>);
          break;
        case 'location':
          return new MapEntry(k, v.toString());
          break;
        default:
          if (validParams.containsKey(k))
            return new MapEntry(k, v);
          else
            throw new Exception('$k is not a valid parameter');
          break;
      }
    });
  }

}