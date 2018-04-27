import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';

/**
 * This class takes a temporarily created Activity object and the field to edit.
 * NOTE: we are directly changing the object here because it is too cumbersome to
 *   generate a new state on every character change, instead we have a temporary object
 *   not part of the app state that holds data entry (this may not be the best solution though).
 */
class ActivityDataInput extends StatefulWidget {
  final int maxLines;
  final Activity activity;
  final String field;

  ActivityDataInput({ this.maxLines, this.activity, this.field });

  @override
  State<ActivityDataInput> createState() => new ActivityDataInputState();
}

class ActivityDataInputState extends State<ActivityDataInput> {

  TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.activity.data[widget.field])
    ..addListener(
      () {
        widget.activity.data[widget.field] = _controller.value.text;
      }
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: new TextField(
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : TextInputType.text,
        maxLines: widget.maxLines,
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 20.0,
        ),
        decoration: new InputDecoration(
          labelText: widget.field,
        ),
        controller: _controller,
      ),
    );
  }

}