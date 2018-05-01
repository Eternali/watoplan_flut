import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_type_card.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Builder(
            builder: (BuildContext context) {
              return new SwitchListTile(
                title: new Text('Join the dark side?'),
                selected: true,
                value: isDark,
                activeColor: Theme.of(context).accentColor,
                onChanged: (newVal) {
                  if (newVal) {
                    if (Theme.of(context) != DarkTheme) Intents.setTheme(Provider.of(context).value, DarkTheme)
                  } else {
                    if (Theme.of(context) != LightTheme) Intents.setTheme(Provider.of(context).value, LightTheme);
                  }
                  setState(() { isDark = newVal; });
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
          new Expanded(
            child: new Column(
              children: <Widget>[
                new ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                      Intents.setFocused(Provider.of(context),indice: -1);
                      Navigator.of(context).pushNamed(Routes.addEditActivityType);
                    },
                  ),
                ),
              ],
            ),
          ),
          //   child: new ListView(
          //     padding: EdgeInsets.symmetric(horizontal: 24.0),
          //     children: [
          //       (stateVal.activityTypes.map(
          //         (it) => new ActivityTypeCard(it)
          //       ).toList() as List<Widget>),
          //       new MaterialButton(
          //         child: new Text('NEW'),
          //         onPressed: () {  },
          //       )
          //     ].expand((l) => l).toList(),
          // ),
          // new Container(
          //   width: double.infinity,
          //   height: 100.0,
          //   child: new Card(
          //     child: new Text('NEW'),
          //   ),
          // ),
        ],
      ),
    );
  }

}
