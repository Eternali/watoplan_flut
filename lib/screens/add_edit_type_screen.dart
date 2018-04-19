import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/color_pick_button.dart';

class AddEditTypeScreen extends StatefulWidget {

  @override
  State<AddEditTypeScreen> createState() => new AddEditTypeScreenState();

}

class AddEditTypeScreenState extends State<AddEditTypeScreen> {

  @override
  Widget build(BuildContext context) {
    // watch out since every time setState is called on this screen, this will be regenerated    
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
            new Center(
              child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 20.0),
                child: new ColorPickButton(activityType: tmpType),
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
          Navigator.pop(context);
        },
      ),
    );
  }

}
