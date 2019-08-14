import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/data/shared_prefs.dart';
import 'package:watoplan/widgets/activity_type_card.dart';

class SettingsScreen extends StatefulWidget {

  bool isDark = false;

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
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

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text(
          locales.settingsTitle
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int choice) {
              if (choice == 0) {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                    title: Text(
                      locales.dataWarning,
                    ),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              locales.cancel,
                              style: theme.textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          FlatButton(
                            child: Text(
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
                    SharedPrefs.getInstance()
                      .then((prefs) => Intents.reset(Provider.of(context), prefs))
                      .then((_) => Intents.initData(Provider.of(context)));
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings_backup_restore),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                    Text(locales.resetApp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return SwitchListTile(
                  title: Text('Join the dark side?'),
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
            
            Container(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Activity Types',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Column(
                  children: stateVal.activityTypes.map(
                    (it) => ActivityTypeCard(it, stateVal.activityTypes.indexOf(it))
                  ).toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(8.0),
                    color: Theme.of(context).accentColor,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Theme.of(context).accentColor
                      )
                    ),
                    child: Icon(Icons.add, size: 34.0),
                    onPressed: () {
                      Intents.setFocused(Provider.of(context), index: -1);
                      Intents.editEditing(Provider.of(context), ActivityType(color: theme.accentColor));
                      Navigator.of(context).pushNamed(Routes.addEditActivityType);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
