import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ColorPicker.dart';

class AddEditTypeScreen extends StatefulWidget {

  @override
  State<AddEditTypeScreen> createState() => new AddEditTypeScreenState();

}

class AddEditTypeScreenState extends State<AddEditTypeScreen> {

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;
    ThemeData theme = Theme.of(context);

    ActivityType tmpType = stateVal.focused >= 0
      ? ActivityType.from(stateVal.activityTypes[stateVal.focused])
      : new ActivityType();

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: tmpType.color ?? theme.accentColor,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          tmpType.name ?? WatoplanLocalizations.of(context).newActivityType
        ),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 20.0),
              child: new RaisedButton(
                padding: new EdgeInsets.all(8.0),
                color: tmpType.color ?? theme.primaryColor,
                child: new Text(
                  'CHOOSE COLOR',
                  style: new TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: () {
                  ColorPicker picker = new ColorPicker(
                    (tmpType.color ?? theme.primaryColor).red.toDouble(),
                    (tmpType.color ?? theme.primaryColor).green.toDouble(),
                    (tmpType.color ?? theme.primaryColor).blue.toDouble()
                  );
                  showDialog<Color>(context: context, child: picker)
                    .then((Color c) {
                      print(c);
                      if (c != null)
                        setState( () => tmpType.color = c );
                    });
                },
              ),
            ),
          ],
        )
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        backgroundColor: tmpType.color ?? theme.accentColor,
        onPressed: () {
          if (stateVal.focused >= 0)
            Intents.changeActivityType(Provider.of(context), stateVal.focused, tmpType);
          else
            Intents.addActivityTypes(Provider.of(context), [tmpType]);
        },
      ),
    );
  }

}
