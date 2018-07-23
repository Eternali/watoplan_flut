import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watoplan/utils/data_utils.dart';

class DateTimePicker extends StatefulWidget {

  DateTime when;
  final String label;
  final setDate;
  final setTime;
  final Color color;

  DateTimePicker({
    Key key,
    this.label,
    this.when,
    this.setDate,
    this.setTime,
    this.color,
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => DateTimePickerState();

}

class DateTimePickerState extends State<DateTimePicker> {

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.when,
      firstDate: DateTime(2018),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.when)
      setState(() {
        widget.when = widget.setDate(picked);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.when),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(widget.when))
      setState(() {
        widget.when = widget.setTime(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                TimeOfDay.fromDateTime(widget.when).format(context),
                style: valueStyle,
              ),
              Icon(Icons.arrow_drop_down, color: widget.color),
            ],
          ),
          onPressed: () { _selectTime(context); },
        ),
        MaterialButton(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateTimeUtils.formatDMY(widget.when),
                style: valueStyle,
              ),
              Icon(Icons.arrow_drop_down, color: widget.color),
            ],
          ),
          onPressed: () { _selectDate(context); },
        ),
      ],
    );
  }

}
