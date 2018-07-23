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
    return DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
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
          return MapEntry(k, dateTimeFromString(v));
          break;
        case 'notis':
          // this is a dumb workaround for type checking
          // List<Noti> x = []; List<Noti> y = <Noti>[]; assert x.runtimeType != y.runtimeType
          List<Noti> value = <Noti>[];
          for (Noti noti in v.map((noti) => Noti.fromJson(noti)).toList()) value.add(noti);
          return MapEntry(k, value);
          break;
        case 'location':
          return MapEntry(k, Location.fromJson(v));
          break;
        // case 'contacts':
        // List<Contact> value = <Contact>[];
        // for (Contact contact in v.map((contact) => Contact.fromJson(contact)).toList()) value.add(contact);
        //   return MapEntry(k, value);
        //   break;
        default:
          if (validParams.containsKey(k))
            return MapEntry(k, v);
          else
            throw Exception('$k is not a valid parameter');
          break;
      }
    });
  }

  static Map<String, dynamic> paramsToJson(Map<String, dynamic> params) {
    return params.map((k, v) {
      switch (k) {
        case 'start':
        case 'end':
          return MapEntry(k, dateTimeToString(v));
          break;
        case 'notis':
          return MapEntry(k, v.map((noti) => noti.toJson()).toList());
          break;
        case 'location':
          return MapEntry(k, v.toJson());
          break;
        case 'contacts':
          return MapEntry(k, v.map((contact) => contact.toJson()).toList());
          break;
        default:
          if (validParams.containsKey(k))
            return MapEntry(k, v);
          else
            throw Exception('$k is not a valid parameter');
          break;
      }
    });
  }

}