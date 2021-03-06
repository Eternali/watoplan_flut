import 'dart:async';

import 'package:flutter/material.dart';

typedef String StrGet();

class WatoplanLocalizations {
  static WatoplanLocalizations of(BuildContext context) {
    return Localizations.of<WatoplanLocalizations>(context, WatoplanLocalizations);
  }

  String get aboutFeedback => 'For feedback, feature requests, or bug reports, please first check';  
  String get aboutTitle => 'About';
  String get addActivity => 'Add Activity';
  String get addActivityType => 'Add Type';
  String get addNotification => 'Add another notification';
  String get appTitle => 'WAToPlan';
  String get by => 'by';
  String get cancel => 'Cancel';
  String get chooseColor => 'Choose Color';
  String get cont => 'Continue';
  String get contacts => 'Related Contacts';
  String get dataWarning => 'Warning, this will delete all your data, continue?';
  String get developFeedback => 'If you\'re a developer with ideas, issues, or just interested in '
    'checking out the app source, you can find us at';
  String get editNoti => 'Edit Notification';
  String get end => 'End';
  String get featureUnavailable => 'This feature isn\'t here yet, sorry!';
  String get featureComingSoon => 'This feature is coming soon!';
  String get invalidType => 'Make sure your type is valid before saving.';
  String get layoutList => 'List';
  String get layoutCalendar => 'Calendar';
  String get layoutUndefined => 'The specified layout can\'t be found.';
  String get newActivity => 'New Activity';
  String get newActivityType => 'New Type';
  String get newNoti => 'New Notification';
  String get newtxt => 'New';
  String get priority => 'Priority';
  String get progress => 'Progress';
  String get remove => 'Remove';
  String get resetApp => 'Reset to Defaults';
  String get reverse => 'Reverse';
  String get reversed => 'Reversed';
  String get save => 'Save';
  String get select => 'Select';
  String get settingsTitle => 'Settings';
  String get start => 'Start';
  String get undo => 'Undo';
  String get updateError => 'This is likely due to an update that caused a breaking change in configuration.'
    'To make the app usable, go to settings and select \'$resetApp\' from the overflow menu. Sorry :(';

  String timeToEarly({ String what, String time }) => '$what must be ${time != null ? 'after $time' : 'sometime in the future'}.';

  // Param locales
  Map<String, StrGet> validParams = {
    'name': () => 'name',
    'desc': () => 'short description',
    'long': () => 'description (Markdown)',
    'priority': () => 'priority',
    'progress': () => 'progress',
    'start': () => 'start',
    'end': () => 'end',
    'notis': () => 'notifications',
    'location': () => 'location',
    'contacts': () => 'contacts',
    // 'tags': () => 'tags',
  };

  // Sort locales
  Map<String, StrGet> validSorts = {
    'start': () => 'start time',
    'end': () => 'end time',
    'priority': () => 'priority',
    'progress': () => 'progress',
    'type': () => 'type',
  };

}

class WatoplanLocalizationsDelegate
    extends LocalizationsDelegate<WatoplanLocalizations> {

  @override
  Future<WatoplanLocalizations> load(Locale locale) {
    return Future(() => WatoplanLocalizations());
  }

  @override
  bool shouldReload(WatoplanLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');

}
