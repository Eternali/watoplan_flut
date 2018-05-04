import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/themes.dart';
import 'package:watoplan/defaults.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/reducers.dart';
import 'package:watoplan/utils/activity_sorters.dart';

class Intents {

  static Future<void> loadAll(AppStateObservable appState) async {
    return getApplicationDocumentsDirectory()
      .then((dir) => new LocalDb('${dir.path}/watoplan.json'))
      .then((db) { db.saveOver(defaultActivityTypes, defaultActivities); return db; })  // for initial dataset population / reset
      .then((db) => db.loadAtOnce())
      // .then((dataStream) async {
      //   await for (var item in dataStream) {
      //     if (item is ActivityType) {
      //       appState.value = Reducers.addActivityTypes(appState.value, [item]);
      //     } else if (item is Activity) {
      //       appState.value = Reducers.addActivities(appState.value, [item]);
      //     }
      //   }
      // });
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

  static Future addActivities(
    AppStateObservable appState, List<Activity> activities,
    [ String typeName ]
  ) async {
    for (Activity activity in activities) {
      await LocalDb().add(activity);
      print(appState.value.notiPlug.toString());
      if (activity.data.keys.contains('notis') && appState.value.notiPlug != null) {
        print('\nScheduling notification\n\n');
        for (Noti noti in activity.data['notis']) {
          noti.schedule(appState.value.notiPlug, activity, typeName);
        }
      }
    }
    appState.value = Reducers.addActivities(appState.value, activities);
  }

  static Future removeActivities(AppStateObservable appState, List<Activity> activities) async {
    for (Activity activity in activities) {
      await LocalDb().remove(activity);
      if (activity.data.keys.contains('notis') && appState.value.notiPlug != null) {
        for (Noti noti in activity.data['notis']) {
          noti.cancel(appState.value.notiPlug);
        }
      }
    }
    appState.value = Reducers.removeActivities(appState.value, activities);
  }

  static Future changeActivity(
    AppStateObservable appState, Activity newActivity,
    [ String typeName ]
  ) async {
    await LocalDb().update(newActivity);
    if (newActivity.data.keys.contains('notis') && appState.value.notiPlug != null) {
      Activity old = appState.value.activities.map(
        (activity) => activity.id
      ).toList().indexOf(newActivity.id);
      old.data['notis']
        .forEach((noti) {
          if (!newActivity.data['notis'].map((n) => n.id).contains(noti.id)) noti.cancel(appState.value.notiPlug);
        });
      newActivity.data['notis']
        .forEach((noti) {
          if (!old.data['notis'].map((n) => n.id).contains(noti.id)) noti.schedule(appState.value.notiPlug, newActivity, typeName);
        });
    }
    appState.value = Reducers.changeActivity(appState.value, newActivity);
  }

  static void setFocused(AppStateObservable appState, { int indice, Activity activity, ActivityType activityType }) {
    appState.value = Reducers.setFocused(appState.value, indice, activity, activityType);
  }

  static void setTheme(AppStateObservable appState, String themeName) async {
    await SharedPreferences.getInstance()
      .then((prefs) => prefs.setString('theme', themeName));
    appState.value = Reducers.setTheme(appState.value, themes[themeName]);
  }

  static void sortActivities(AppStateObservable appState, String sorterName) async {
    await SharedPreferences.getInstance()
      .then((prefs) => prefs.setString('sorter', sorterName));
    appState.value = Reducers.replaceActivities(appState.value, validSorts[sorterName](appState.value.activities));
  }

}

