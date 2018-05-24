import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/init_plugs.dart';
import 'package:watoplan/run_after.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/data/reducers.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/screens/home_screen.dart';
import 'package:watoplan/screens/add_edit_screen.dart';
import 'package:watoplan/screens/add_edit_type_screen.dart';
import 'package:watoplan/screens/settings_screen.dart';
import 'package:watoplan/screens/about_screen.dart';

void main() async {
  runApp(
    new Watoplan()
  );
  await runDelayed();
}

class Watoplan extends StatefulWidget {

  // NOTE: we must initialize the state with empty data because
  // Flutter will not wait for the constructor to finish its asyncronous
  // operations before building the widget tree.

  AppStateObservable watoplanState;

  Watoplan() {
    watoplanState = new AppStateObservable(Reducers.firstDefault);
  }

  @override
  State<Watoplan> createState() => new WatoplanState();

}

class WatoplanState extends State<Watoplan> {

  @override
  Widget build(BuildContext context) {
    if (notiPlug != null) {
      notiPlug.onSelectNotification = (String payload) async {

      };
    }
    // getApplicationDocumentsDirectory()
    //   .then((dir) => LevelDB.openUtf8('${dir.path}/testdb'))
    //   .then((db) {
    //     db.put('testkey', 'testval');
    //     print('testing: testkey = ${db.get('testkey')}');
    //   });
    return new Provider(
      state: widget.watoplanState,
      child: new MaterialApp(
        title: 'watoplan',
        localizationsDelegates: [
          new WatoplanLocalizationsDelegate()
        ],
        routes: {
          Routes.home: (context) => new HomeScreen(title: 'WAToPlan'),
          Routes.addEditActivity: (context) => new AddEditScreen(),
          Routes.addEditActivityType: (context) => new AddEditTypeScreen(),
          Routes.settings: (context) => new SettingsScreen(),
          Routes.about: (context) => new AboutScreen(),
        },
        builder: (BuildContext context, Widget child) => new Theme(
          data: Provider.of(context).value.theme ?? themes['light'],
          child: new SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }

}
