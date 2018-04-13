import 'package:flutter/material.dart';

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

}
