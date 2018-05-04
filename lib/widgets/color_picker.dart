import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';

class ColorPicker extends StatefulWidget {

  double r, g, b;
  ColorPicker([this.r, this.g, this.b]);

  @override
  State<ColorPicker> createState() => new ColorPickerState(r, g, b);

}

class ColorPickerState extends State<ColorPicker> {

  double r, g, b;
  ColorPickerState([this.r, this.g, this.b]);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: new EdgeInsets.all(0.0),
      content: new IntrinsicWidth(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new ClipRect(
              child: new Container(
                width: 50.0,
                height: 180.0,
                decoration: new BoxDecoration(
                  color: new Color.fromARGB(255, r.round(), g.round(), b.round()),
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 30.0),
            ),
            new Slider(
              value: r,
              min: 0.0,
              max: 255.0,
              activeColor: Colors.red[400],
              onChanged: (double value) {
                setState(() { r = value; });
              }
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 10.0)
            ),
            new Slider(
              value: g,
              min: 0.0,
              max: 255.0,
              activeColor: Colors.green[400],
              onChanged: (double value) {
                setState(() { g = value; });
              }
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 10.0)
            ),
            new Slider(
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
        new FlatButton(
          child: new Text(
            WatoplanLocalizations.of(context).cancel,
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        new FlatButton(
          child: new Text(
            WatoplanLocalizations.of(context).select,
          ),
          onPressed: () {
            Color c = new Color.fromARGB(255, r.round(), g.round(), b.round());
            Navigator.pop(context, c);
          },
        )
      ],
    );
  }

}

