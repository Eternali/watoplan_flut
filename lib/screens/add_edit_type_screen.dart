import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/color_pick_button.dart';
import 'package:watoplan/widgets/edit_text.dart';
import 'package:watoplan/widgets/icon_pick_button.dart';

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
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              WatoplanLocalizations.of(context).save.toUpperCase()
            ),
            onPressed: () {
              if (stateVal.focused >= 0) Intents.changeActivityType(Provider.of(context), tmpType);
              else Intents.addActivityTypes(Provider.of(context), [tmpType]);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: new Padding(
        padding: new EdgeInsets.symmetric(horizontal: 8.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: new EditText(
                  maxLines: 1,
                  label: 'Name',
                  initVal: tmpType.name,
                  editField: (String changed) { tmpType.name = changed; },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: new IconPickButton(
                  label: 'Choose Icon',
                  curIcon: tmpType.icon,
                  changeIcon: (IconData changed) { setState(() { tmpType.icon = changed; }); },
                ),
              ),
              new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new ColorPickButton(activityType: tmpType),
              ),
            ],
          ),
        ),
          // child: new Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     new Padding(
          //       padding: new EdgeInsets.symmetric(vertical: 20.0),
          //       child: new ColorPickButton(activityType: tmpType),
          //     ),
          //   ],
          // ),
      ),
    );
  }

}
