import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/widgets/color_picker.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/themes.dart';

class ColorPickButton extends StatefulWidget {

  ActivityType activityType;
  ColorPickButton({ this.activityType });

  @override
  State<ColorPickButton> createState() => ColorPickButtonState(activityType: activityType);

}

class ColorPickButtonState extends State<ColorPickButton> {

  ActivityType activityType;
  ColorPickButtonState({ this.activityType });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return RaisedButton(
      padding: EdgeInsets.all(12.0),
      color: activityType.color ?? theme.accentColor,
      child: Text(
        WatoplanLocalizations.of(context).chooseColor,
        style: TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.2,
        ),
      ),
      onPressed: () {
        ColorPicker picker = ColorPicker(
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

