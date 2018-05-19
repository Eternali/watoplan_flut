import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static DateTime fromDate(DateTime source, DateTime date) {
    return new DateTime(
      date.year,
      date.month,
      date.day,
      source.hour,
      source.minute,
      source.second,
      source.millisecond,
    );
  }

  static DateTime copyWith(DateTime source,
    { int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond }
  ) {
    return new DateTime(
      year ?? source.year,
      month ?? source.month,
      day ?? source.day,
      hour ?? source.hour,
      minute ?? source.minute,
      second ?? source.second,
      millisecond ?? source.millisecond,
      microsecond ?? source.microsecond,
    );
  }

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
    // return '${date.day.toString().padLeft(2, '0')}/'
    //        '${date.month.toString().padLeft(2, '0')}/'
    //        '${date.year.toString().padLeft(2, '0')}';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDMYT(DateTime date) {
    return '${formatDMY(date)} at ${DateFormat('HH:mm').format(date)}';
  }

  static String formatEM(DateTime date) {
    return '${DateFormat('MMM d').format(date)} at ${DateFormat('HH:mm').format(date)}';
  }

}
