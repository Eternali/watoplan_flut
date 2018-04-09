import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }

}
