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
    Watoplan()
  );
  await runDelayed();
}

class Watoplan extends StatefulWidget {

  // NOTE: we must initialize the state with empty data because
  // Flutter will not wait for the constructor to finish its asyncronous
  // operations before building the widget tree.

  AppStateObservable watoplanState;

  Watoplan() {
    watoplanState = AppStateObservable(Reducers.firstDefault);
  }

  @override
  State<Watoplan> createState() => WatoplanState();

}

class WatoplanState extends State<Watoplan> {

  @override
  Widget build(BuildContext context) {
    if (notiPlug != null) {
      notiPlug.onSelectNotification = (String payload) async {

      };
    }

    return Provider(
      state: widget.watoplanState,
      child: MaterialApp(
        title: 'watoplan',
        localizationsDelegates: [
          WatoplanLocalizationsDelegate()
        ],
        routes: {
          Routes.home: (context) => HomeScreen(title: 'WAToPlan'),
          Routes.addEditActivity: (context) => AddEditScreen(),
          Routes.addEditActivityType: (context) => AddEditTypeScreen(),
          Routes.settings: (context) => SettingsScreen(),
          Routes.about: (context) => AboutScreen(),
        },
        builder: (BuildContext context, Widget child) => Theme(
          data: Provider.of(context).value.theme ?? themes['light'],
          child: child,
        ),
      ),
    );
  }

}
