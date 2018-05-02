import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {



  @override
  State<IconPicker> createState() => new IconPickerState();

}

class IconPickerState extends State<IconPicker> {

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: new EdgeInsets.all(8.0),
      content: new Center(),
    );
  }

}
