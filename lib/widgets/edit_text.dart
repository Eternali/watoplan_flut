import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final int maxLines;
  final TextAlign alignment;
  final String label;
  final String initVal;
  final Function editField;

  EditText({ this.maxLines = 1, this.alignment = TextAlign.center, this.label, this.initVal, this.editField});

  @override
  State<EditText> createState() => EditTextState();
}

class EditTextState extends State<EditText> {

  TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initVal)
      ..addListener(() => widget.editField(_controller.value.text));
  }

  @override
  dispose() {
    _controller.removeListener(() => widget.editField(_controller.value.text));
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: TextField(
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : TextInputType.text,
        maxLines: widget.maxLines,
        textAlign: widget.alignment,
        style: Theme.of(context).textTheme.body1.copyWith(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(),
        ),
        controller: _controller,
      ),
    );
  }

}