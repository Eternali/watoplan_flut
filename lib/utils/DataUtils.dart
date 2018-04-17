import 'package:flutter/material.dart';

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
