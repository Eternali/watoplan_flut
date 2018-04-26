import 'dart:async';

import 'package:flutter/material.dart';

class WatoplanLocalizations {
  static WatoplanLocalizations of(BuildContext context) {
    return Localizations.of<WatoplanLocalizations>(context, WatoplanLocalizations);
  }

  String get appTitle => 'WAToPlan';
  String get addActivity => 'Add Activity';
  String get newActivity => 'New Activity';
  String get addActivityType => 'Add Type';
  String get newActivityType => 'New Type';
  String get settingsTitle => 'Settings';
  String get aboutTitle => 'About';
  String get save => 'Save';

  String get chooseColor => 'Choose Color';

  String get remove => 'Remove';

  String get priority => 'Priority';
  String get progress => 'Progress';

  String get addNotification => 'Add another notification';

}

class WatoplanLocalizationsDelegate
    extends LocalizationsDelegate<WatoplanLocalizations> {

  @override
  Future<WatoplanLocalizations> load(Locale locale) {
    return new Future(() => new WatoplanLocalizations());
  }

  @override
  bool shouldReload(WatoplanLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');

}
