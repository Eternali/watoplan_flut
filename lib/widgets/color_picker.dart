import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';

class ColorPicker extends StatefulWidget {

  double r, g, b;
  ColorPicker([this.r, this.g, this.b]);

  @override
  State<ColorPicker> createState() => ColorPickerState(r, g, b);

}

class ColorPickerState extends State<ColorPicker> {

  double r, g, b;
  ColorPickerState([this.r, this.g, this.b]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRect(
              child: Container(
                width: 50.0,
                height: 180.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, r.round(), g.round(), b.round()),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
            ),
            Slider(
              value: r,
              min: 0.0,
              max: 255.0,
              activeColor: Colors.red[400],
              onChanged: (double value) {
                setState(() { r = value; });
              }
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0)
            ),
            Slider(
              value: g,
              min: 0.0,
              max: 255.0,
              activeColor: Colors.green[400],
              onChanged: (double value) {
                setState(() { g = value; });
              }
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0)
            ),
            Slider(
              value: b,
              min: 0.0,
              max: 255.0,
              activeColor: Colors.blue[400],
              onChanged: (double value) {
                setState(() { b = value; });
              }
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            WatoplanLocalizations.of(context).cancel,
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        FlatButton(
          child: Text(
            WatoplanLocalizations.of(context).select,
          ),
          onPressed: () {
            Color c = Color.fromARGB(255, r.round(), g.round(), b.round());
            Navigator.pop(context, c);
          },
        )
      ],
    );
  }

}

