import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';

int generateId([int length = 10]) {
  if (length < 4 || length > 18) throw new Exception('Invalid length');
  String now = DateTime.now().millisecondsSinceEpoch.toString();
  int div = (length / 2).round();
  return int.parse(
    Random().nextInt(10 * div).toString().padLeft(div, '0') +
    now.substring(now.length - div)
  );
}

BigInt generateLargeId([int length = 24]) {
  String now = DateTime.now().millisecondsSinceEpoch.toString();
  int div = (length / 2).round();
  return BigInt.parse(
    Random().nextInt(10 * div).toString().padLeft(div, '0') +
    now.substring(now.length - div)
  );
}

String generateUniqueId(String value) {
  return hex.encode(crypto.md5.convert(Utf8Encoder().convert(value)).bytes);
}

/**
 * WHY NO EXTENSION METHODS???
 */
class DateTimeUtils {

  static DateTime fromTimeOfDay(DateTime source, TimeOfDay time) {
    return new DateTime(
      source.year,
      source.month,
      source.day,
      time.hour,
      time.minute,
      source.second,
      source.millisecond,
    );
  }

  static String formatDMY(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year.toString().padLeft(2, '0')}';
  }

}
