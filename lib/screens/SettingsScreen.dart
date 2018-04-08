import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

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
          new SwitchListTile(
            title: new Text('Join the dark side?'),
            value: true,
            selected: true,
            activeColor: Theme.of(context).accentColor,
            onChanged: (newVal) {},
          )
        ],
      ),
    );
  }

}
