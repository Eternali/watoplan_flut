import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_type_card.dart';

class SettingsScreen extends StatefulWidget {

  bool isDark = false;

  @override
  State<SettingsScreen> createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    final locales = WatoplanLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    themes.forEach((name, theme) {
      if (stateVal.theme == theme) {
        widget.isDark = name == 'dark';
        return;
      }
    });

    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          locales.settingsTitle
        ),
        actions: <Widget>[
          new PopupMenuButton<int>(
            onSelected: (int choice) {
              if (choice == 0) {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => new SimpleDialog(
                    title: new Text(
                      locales.dataWarning,
                    ),
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text(
                              locales.cancel,
                              style: theme.textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          new FlatButton(
                            child: new Text(
                              locales.cont,
                              style: theme.textTheme.button.copyWith(
                                color: theme.accentColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ).then((cont) {
                  if (cont) {
                    SharedPreferences.getInstance()
                      .then((prefs) => Intents.reset(Provider.of(context), prefs))
                      .then((_) => Intents.initData(Provider.of(context)));
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              new PopupMenuItem<int>(
                value: 0,
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.settings_backup_restore),
                    new Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                    new Text(locales.resetApp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Builder(
            builder: (BuildContext context) {
              return new SwitchListTile(
                title: new Text('Join the dark side?'),
                selected: true,
                value: widget.isDark,
                activeColor: Theme.of(context).accentColor,
                onChanged: (newVal) {
                  if (newVal) {
                    if (Theme.of(context) != themes['dark']) Intents.setTheme(Provider.of(context), 'dark');
                  } else {
                    if (Theme.of(context) != themes['light']) Intents.setTheme(Provider.of(context), 'light');
                  }
                  setState(() { widget.isDark = newVal; });
                },
              );
            }
          ),
          
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
          ),
          new Column(
            children: <Widget>[
              new Column(
                children: stateVal.activityTypes.map(
                  (it) => new ActivityTypeCard(it, stateVal.activityTypes.indexOf(it))
                ).toList(),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: new RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).accentColor,
                  shape: new CircleBorder(
                    side: new BorderSide(
                      color: Theme.of(context).accentColor
                    )
                  ),
                  child: new Icon(Icons.add, size: 34.0),
                  onPressed: () {
                    Intents.setFocused(Provider.of(context), indice: -1);
                    Intents.editEditing(Provider.of(context), new ActivityType(color: theme.accentColor));
                    Navigator.of(context).pushNamed(Routes.addEditActivityType);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
