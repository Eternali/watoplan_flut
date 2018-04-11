import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/widgets/ColorPicker.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/themes.dart';

class ColorPickButton extends StatefulWidget {

  ActivityType activityType;
  ColorPickButton({this.activityType});

  @override
  State<ColorPickButton> createState() => new ColorPickButtonState(activityType: activityType);

}

class ColorPickButtonState extends State<ColorPickButton> {

  ActivityType activityType;
  ColorPickButtonState({this.activityType});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return new RaisedButton(
      padding: new EdgeInsets.all(12.0),
      color: activityType.color ?? theme.accentColor,
      child: new Text(
        WatoplanLocalizations.of(context).chooseColor,
        style: new TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.2,
        ),
      ),
      onPressed: () {
        ColorPicker picker = new ColorPicker(
          (activityType.color ?? theme.accentColor).red.toDouble(),
          (activityType.color ?? theme.accentColor).green.toDouble(),
          (activityType.color ?? theme.accentColor).blue.toDouble()
        );
        showDialog<Color>(context: context, child: picker)
          .then((Color c) {
            if (c != null)
              setState( () { activityType.color = c; } );
          });
      },
    );
  }

}

