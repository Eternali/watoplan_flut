import 'dart:convert' show JSON;

import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

class Converters {

  static IconData iconFromString(String iconStr) {

  }

  static String iconToString(IconData icon) {

  }

  static Color colorFromHex(int colorStr) {
    return new Color(colorStr);
  }

  static String colorToString(Color color) {
    return color.toString();
  }

  static Map<String, dynamic> paramsFromJson(Map<String, dynamic> params) {
    return params.map((k, v) {
      // if (v)
    });
  }

  static Map<String, dynamic> paramsToJson(Map<String, dynamic> params) {
    return params.map((k, v) {
      if (v is IconData) return new MapEntry(k, iconToString(v));
      else if (v is Color) return new MapEntry(k, colorToString(v));
    });
  }

}