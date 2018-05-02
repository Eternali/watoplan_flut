import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/defaults.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/reducers.dart';

class Intents {

  static Future<void> loadAll(AppStateObservable appState) async {
    return getApplicationDocumentsDirectory()
      .then((dir) => new LocalDb('${dir.path}/watoplan.json'))
      .then((db) { db.saveOver(defaultActivityTypes, defaultActivities); return db; })  // for initial dataset population / reset
      .then((db) => db.load())
      .then((data) {
        appState.value = Reducers.set(
          activityTypes: data[0],
          activities: data[1],
          focused: appState.value.focused,
          theme: appState.value.theme,
        );
      });
  }

  static Future addActivityTypes(AppStateObservable appState, List<ActivityType> activityTypes) async {
    for (ActivityType type in activityTypes) {
      await LocalDb().add(type);
    }
    appState.value = Reducers.addActivityTypes(appState.value, activityTypes);
  }

  static Future removeActivityTypes(AppStateObservable appState, List<ActivityType> activityTypes) async {
    for (ActivityType type in activityTypes) await LocalDb().remove(type);
    appState.value = Reducers.removeActivityTypes(appState.value, activityTypes);
  }

  static Future changeActivityType(AppStateObservable appState, ActivityType newType) async {
    await LocalDb().update(newType);
    appState.value = Reducers.changeActivityType(appState.value, newType);
  }

  static Future addActivities(AppStateObservable appState, List<Activity> activities) async {
    for (Activity activity in activities) {
      await LocalDb().add(activity);
    }
    appState.value = Reducers.addActivities(appState.value, activities);
  }

  static Future removeActivities(AppStateObservable appState, List<Activity> activities) async {
    for (Activity activity in activities) await LocalDb().remove(activity);
    appState.value = Reducers.removeActivities(appState.value, activities);
  }

  static Future changeActivity(AppStateObservable appState, Activity newActivity) async {
    print(newActivity.toJson());
    await LocalDb().update(newActivity);
    appState.value = Reducers.changeActivity(appState.value, newActivity);
  }

  static void setFocused(AppStateObservable appState, {int indice, Activity activity, ActivityType activityType}) {
    appState.value = Reducers.setFocused(appState.value, indice, activity, activityType);
  }

  static void setTheme(AppStateObservable appState, String themeName) async {
    await SharedPreferences.getInstance()
      .then((SharedPreferences prefs) => prefs.setString('theme', themeName));
    appState.value = Reducers.setTheme(appState.value, themes[themeName]);
  }

}

