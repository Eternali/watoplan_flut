import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watoplan/utils/DataUtils.dart';

class DateTimePicker extends StatelessWidget {

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(2013, 0),
      lastDate: new DateTime(2100, 0)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(child: new Container()),
        new MaterialButton(
          padding: new EdgeInsets.all(12.0),
          child: new Text(
            selectedTime.format(context),
            style: valueStyle,
          ),
          onPressed: () { _selectTime(context); },
        ),
        new Expanded(child: new Container()),
        new MaterialButton(
          padding: new EdgeInsets.all(12.0),
          child: new Text(
            DateTimeUtils.formatDMY(selectedDate),
            style: valueStyle,
          ),
          onPressed: () { _selectDate(context); },
        ),
        new Expanded(child: new Container()),
      ],
    );
  }

}
