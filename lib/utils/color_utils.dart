import 'package:flutter/material.dart';

int hashCode(str) {
    var hash = 0;
    for (var i = 0; i < str.length; i++) {
       hash = str.charCodeAt(i) + ((hash << 5) - hash);
    }
    return hash;
} 

Color intToColor(int i) {
  String c = (i & 0x00FFFFFF).toRadixString(16).toUpperCase();
  return Color(int.parse('00000'.substring(0, 6 - c.length) + c, radix: 16)).withAlpha(255);
}
