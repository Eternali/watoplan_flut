import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef Future OnSave<T>(T value);

class DualDatetime extends StatefulWidget {

  DateFormat format;
  Widget child;
  OnSave<DateTime> onSave;
  DateTime when;

  DualDatetime({
    this.format,
    this.when,
    @required this.child,
    @required this.onSave,
  }) {
    format ??= DateFormat('Hm, E, d MMM y');
    when ??= DateTime.now();
  }

  @override
  State<DualDatetime> createState() => _DualDatetimeState();

}

class _DualDatetimeState extends State<DualDatetime> {

  void _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.when,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100)
    );
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.when),
    );
    await widget.onSave(Utils.fromTimeOfDay(date, time));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        _selectDateTime(context);
      },
    );
  }

}

