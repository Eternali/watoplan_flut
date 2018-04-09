import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ActivityTypeCard.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;

    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          WatoplanLocalizations.of(context).settingsTitle
        ),
      ),
      body: new Column(
        children: <Widget>[
          new Builder(
            builder: (BuildContext context) {
              return new SwitchListTile(
                title: new Text('Join the dark side?'),
                selected: true,
                value: isDark,
                activeColor: Theme.of(context).accentColor,
                onChanged: (newVal) {
                  newVal
                    ? Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text('Dark Theme'),
                      )
                    )
                    : Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text('Light Theme'),
                      )
                    );
                  setState(() { isDark = newVal; });
                },
              );
            }
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(bottom: 12.0),
                child: new Text(
                  'Activity Types',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          new Expanded(
            child: new ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: stateVal.activityTypes.map(
                (it) => new ActivityTypeCard(it)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

}
