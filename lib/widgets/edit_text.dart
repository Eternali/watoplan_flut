import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final int maxLines;
  final String label;
  final String initVal;
  final Function editField;

  EditText({ this.maxLines, this.label, this.initVal, this.editField});

  @override
  State<EditText> createState() => new EditTextState();
}

class EditTextState extends State<EditText> {

  TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.initVal)
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
          labelText: widget.label,
        ),
        controller: _controller,
      ),
    );
  }

}