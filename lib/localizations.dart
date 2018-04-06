import 'dart:async';

import 'package:flutter/material.dart';

class WatoplanLocalizations {
  static WatoplanLocalizations of(BuildContext context) {
    return Localizations.of<WatoplanLocalizations>(context, WatoplanLocalizations);
  }

  String get appTitle => 'WAToPlan';
  String get addActivity => 'Add Activity';
  String get newActivity => 'New Activity';
  String get settingsTitle => 'Settings';

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
