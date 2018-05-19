import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/themes.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/reducers.dart';
import 'package:watoplan/utils/load_defaults.dart';

class Intents {

  static Future<void> loadAll(AppStateObservable appState) async {
    return getApplicationDocumentsDirectory()
      .then((dir) => new LocalDb('${dir.path}/watoplan.json'))
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
        if (data[0].length < 1) {
          return LoadDefaults.loadDefaultData()
            .then((_) {
              LocalDb().saveOver(LoadDefaults.defaultData[0], LoadDefaults.defaultData[1]);
              return LoadDefaults.defaultData;
            });
        } else return data;
      }).then((data) {
        // Damn dart and its terrible type inferencing
        appState.value = Reducers.set(
          activityTypes: (data as List)[0],
          activities: (data as List)[1],
          focused: appState.value.focused,
          theme: appState.value.theme,
          sorter: appState.value.sorter,
          sortRev: appState.value.sortRev,
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
    for (ActivityType type in activityTypes) {
      await Intents.removeActivities(appState, appState.value.activities.where((a) => a.typeId == type.id).toList().retype<Activity>());
      await LocalDb().remove(type);
    }
    appState.value = Reducers.removeActivityTypes(appState.value, activityTypes);
  }

  static Future changeActivityType(AppStateObservable appState, ActivityType newType) async {
    await LocalDb().update(newType);
    appState.value = Reducers.changeActivityType(appState.value, newType);
  }

  static Future addActivities(
    AppStateObservable appState, List<Activity> activities,
    [ FlutterLocalNotificationsPlugin notiPlug, String typeName ]
  ) async {
    for (Activity activity in activities) {
      await LocalDb().add(activity);
      if (activity.data.keys.contains('notis') && notiPlug != null) {
        for (Noti noti in activity.data['notis']) {
          await noti.schedule(
            notiPlug: notiPlug,
            typeName: typeName,
            channel: activity.typeId.toString(),
            base: activity.data.containsKey('start') ? activity.data['start'] : activity.data['end'],
          );
        }
      }
    }
    appState.value = Reducers.addActivities(appState.value, activities);
  }

  static Future removeActivities(
    AppStateObservable appState, List<Activity> activities,
    [ FlutterLocalNotificationsPlugin notiPlug ]
  ) async {
    for (Activity activity in activities) {
      await LocalDb().remove(activity);
      if (activity.data.keys.contains('notis') && notiPlug != null) {
        for (Noti noti in activity.data['notis']) {
          await noti.cancel(notiPlug);
        }
      }
    }
    appState.value = Reducers.removeActivities(appState.value, activities);
  }

  static Future changeActivity(
    AppStateObservable appState, Activity newActivity,
    [ FlutterLocalNotificationsPlugin notiPlug, String typeName ]
  ) async {
    await LocalDb().update(newActivity);
    if (newActivity.data.keys.contains('notis') && notiPlug != null) {
      Activity old = appState.value.activities[
        appState.value.activities.map((activity) => activity.id)
          .toList().indexOf(newActivity.id)
      ];

      String poi = old.data.containsKey('start') ? 'start' : 'end';
      if (old.data[poi].millisecondsSinceEpoch != newActivity.data[poi].millisecondsSinceEpoch) {
        for (Noti noti in newActivity.data['notis']) {
          await noti.cancel(notiPlug);
          await noti.schedule(
            notiPlug: notiPlug,
            typeName: typeName,
            channel: newActivity.typeId.toString(),
            base: newActivity.data[poi],
          );
        }
      }

      var newIds = newActivity.data['notis'].map((n) => n.id);
      var oldIds = old.data['notis'].map((n) => n.id);
      await Future.wait<dynamic>(old.data['notis']
        .where((Noti noti) => !newIds.contains(noti.id))
        .map((Noti noti) => noti.cancel(notiPlug)).retype<Future<void>>()
      );
      await Future.wait<dynamic>(newActivity.data['notis']
        .where((Noti noti) => !oldIds.contains(noti.id))
        .map((Noti noti) =>
          noti.schedule(
            notiPlug: notiPlug,
            typeName: typeName,
            channel: newActivity.typeId.toString(),
            base: newActivity.data[poi],
          )
        ).retype<Future<void>>()
      );
    }
    appState.value = Reducers.changeActivity(appState.value, newActivity);
  }

  static void sortActivities(AppStateObservable appState, [ String sorterName, bool reversed ]) async {
    if (sorterName != null)
      await SharedPreferences.getInstance()
        .then((prefs) { prefs.setString('sorter', sorterName); return prefs; })
        .then((prefs) => prefs.setBool('sortRev', reversed));
    appState.value = Reducers.sortActivities(appState.value, sorterName ?? appState.value.sorter, reversed ?? appState.value.sortRev);
  }

  static void setFocused(AppStateObservable appState, { int indice, Activity activity, ActivityType activityType }) {
    appState.value = Reducers.setFocused(appState.value, indice, activity, activityType);
  }

  static void editEditing(AppStateObservable appState, dynamic editing) {
    appState.value = Reducers.editEditing(appState.value, editing);
  }

  static void inlineChange(
    AppStateObservable appState,
    dynamic editor,
    { String param, dynamic value, String name, IconData icon, Color color, Map<String, dynamic> params }
  ) {
    if (editor is Activity && param != null) {
      appState.value = Reducers.inlineEditChange(
        appState.value,
        Activity,
        () => editor.copyWith(entries: [ new MapEntry(param, value ?? validParams[param]) ]));
    } else if (editor is ActivityType) {
      appState.value = Reducers.inlineEditChange(
        appState.value,
        ActivityType,
        () => new ActivityType(
          name: name ?? editor.name,
          icon: icon ?? editor.icon,
          color: color ?? editor.color,
          params: params ?? editor.params,
        )
      );

    }

  }

  static void clearEditing(AppStateObservable appState, dynamic clearing) {
    appState.value = Reducers.clearEditing(appState.value, clearing);
  }

  static void setTheme(AppStateObservable appState, String themeName) async {
    await SharedPreferences.getInstance()
      .then((prefs) => prefs.setString('theme', themeName));
    appState.value = Reducers.setTheme(appState.value, themes[themeName]);
  }

}
