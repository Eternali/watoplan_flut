import 'dart:async';

import 'package:flutter/material.dart';

class DialogUtils {

  static Future<DateTime> selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(2018, 1),
      lastDate: new DateTime(2100),
    );
    return picked ?? initialDate;
  }

  static Future<DateTime> selectTime(BuildContext context, DateTime initialTime) async {
    
  }

}
