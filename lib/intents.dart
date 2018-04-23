import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:watoplan/defaults.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/reducers.dart';

class Intents {

  static Future<void> loadAll(AppStateObservable appState) async {
    return getApplicationDocumentsDirectory()
      .then((dir) => new LocalDb('${dir.path}/watoplan.json'))
      // .then((db) { db.saveOver(defaultActivityTypes, defaultActivities); return db; })
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

  static void removeActivityTypes(AppStateObservable appState,
      {List<int> indices = const [], List<ActivityType> activityTypes = const []}) {
    if (indices.length > 0)
      appState.value = Reducers.removeActivityTypes(appState.value, indices: indices);    
    else if (activityTypes.length > 0)
      appState.value = Reducers.removeActivityTypes(appState.value, activityTypes: activityTypes);
  }

  static void changeActivityType(AppStateObservable appState, int indice, ActivityType newType) {
    appState.value = Reducers.changeActivityType(appState.value, indice, newType);
  }

  static Future addActivities(AppStateObservable appState, List<Activity> activities) async {
    for (Activity activity in activities) {
      await LocalDb().add(activity);
    }
    appState.value = Reducers.addActivities(appState.value, activities);
  }

  static void removeActivities(AppStateObservable appState,
      {List<int> indices = const [], List<Activity> activities = const []}) {
    if (indices.length > 0)
      appState.value = Reducers.removeActivities(appState.value, indices: indices);    
    else if (activities.length > 0)
      appState.value = Reducers.removeActivities(appState.value, activities: activities);
  }

  static void changeActivity(AppStateObservable appState, int indice, Activity newActivity) async {
    // await LocalDb().update(newActivity);
    appState.value = Reducers.changeActivity(appState.value, indice, newActivity);
  }

  static void setFocused(AppStateObservable appState, {int indice, Activity activity, ActivityType activityType}) {
    appState.value = Reducers.setFocused(appState.value, indice, activity, activityType);
  }

  static void setTheme(AppStateObservable appState, ThemeData theme) {
    appState.value = Reducers.setTheme(appState.value, theme);
  }

}

