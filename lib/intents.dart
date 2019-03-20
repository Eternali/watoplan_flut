import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'package:watoplan/themes.dart';
import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/reducers.dart';
import 'package:watoplan/data/shared_prefs.dart';
import 'package:watoplan/utils/load_defaults.dart';

typedef T SaveFilter<T>();

class Intents {

  static Future initData(AppStateObservable appState) =>
    (LoadDefaults.icons.length < 1 ? LoadDefaults.loadIcons() : Future.value(LoadDefaults.icons))
      .then((_) => loadAll(appState))
      .then((_) => SharedPrefs.getInstance())
      .then((prefs) => initSettings(appState, prefs));

  static Future<void> refresh(AppStateObservable appState) async {
    appState.value = Reducers.refresh(appState.value);
  }

  static Future<void> loadAll(AppStateObservable appState) async {
    final Directory dir = (Platform.isAndroid || Platform.isIOS) ? await getApplicationDocumentsDirectory() : Directory.current;
    final db = LocalDb('${dir.path}/watoplan.json');
    return db.loadAtOnce()
      .then((data) {
        if (data[0].length < 1) {
          return ((LoadDefaults.defaultData.keys.length < 1
            ? LoadDefaults.loadDefaultData()
            : Future.value(LoadDefaults.defaultData)
            )).then((_) {
              var types = LoadDefaults.defaultData['activityTypes']
                ?.map((type) => ActivityType.fromJson(type))
                .cast<ActivityType>().toList() ?? <ActivityType>[];
              var activities = LoadDefaults.defaultData['activities']
                ?.map((activity) => Activity.fromJson(activity, types))
                .cast<Activity>().toList() ?? <Activity>[];
              return LocalDb().saveOver(types, activities)
                .then((_) => [types, activities]);
            });
        } else return data;
      }).then((data) {
        appState.value = Reducers.setData(
          appState.value,
          activityTypes: (data as List)[0],
          activities: (data as List)[1],
        );
      });
  }

  static Future initSettings(AppStateObservable appState, SharedPrefs prefs) async {
    if (LoadDefaults.defaultData.keys.length < 1) await LoadDefaults.loadDefaultData();
    Map<String, dynamic> settings = {
      'focused': LoadDefaults.defaultData['focused'] ?? 0,
      'focusedDate': Converters.dateTimeFromString(await prefs.getString('focusedDate')) ?? DateTime.now(),
      'theme': (await prefs.getString('theme')) ?? LoadDefaults.defaultData['theme'] ?? 'light',
      'needsRefresh': LoadDefaults.defaultData['needsRefresh'] ?? false,
      'homeLayout': (await prefs.getString('homeLayout')) ?? LoadDefaults.defaultData['homeLayout'] ?? 'list',
      'homeOptions': (await prefs.getString('homeOptions')) != null
        ? await prefs.getJson('homeOptions')
        : LoadDefaults.defaultData['homeOptions'] ?? Reducers.firstDefault.homeOptions,
      'filters': await prefs.getJson('filters') ?? {}
    };
    settings = await ensureBackwardsCompatible(settings);
    return setTheme(appState, settings['theme'])
      .catchError((e) => setTheme(appState, 'light'))
      .then((_) => switchHome(
        appState,
        layout: settings['homeLayout'],
        options: settings['homeOptions'][settings['homeLayout']]
      ))
      .then((_) => setFocused(appState, index: settings['focused']))
      .then((_) => focusOnDay(appState, settings['focusedDate']))
      .then((_) => Future.wait(settings['filters'].entries.map<Future>(
        (MapEntry<String, dynamic> entry) => applyFilter(appState, entry.key, () => entry.value)
      )))
      .then((_) => sortActivities(appState, layout: settings['homeLayout']));
  }

  static Future ensureBackwardsCompatible(Map<String, dynamic> settings) {
    return Future.value(
      // Make sure homeLayout is safe to use
      settings..['homeLayout'] = AppState.safeHomeLayout(settings['homeLayout'])
    );
  }

  static Future reset(AppStateObservable appState, SharedPrefs prefs) async {
    await LocalDb().delete();
    await prefs.remove('theme');
    await prefs.remove('homeLayout');
    await prefs.remove('homeOptions');
    appState.value = Reducers.firstDefault;
  }

  static Future switchHome(
    AppStateObservable appState,
    { String layout, Map<String, dynamic> options }
  ) async {
    final prefs = await SharedPrefs.getInstance();
    await prefs.setString('homeLayout', layout);
    await prefs.setString('homeOptions', json.encode(appState.value.homeOptions..[layout] = options));
    appState.value = Reducers.switchHome(appState.value, layout: layout, options: options);
    return layout;
    // validLayouts[layout].onChange(appState, options);
  }

  static Future<bool> addActivityTypes(AppStateObservable appState, List<ActivityType> activityTypes) async {
    for (ActivityType type in activityTypes) {
    if (type.params.keys.length < 1 || type.name == '') return false;      
      await LocalDb().add(type);
    }
    appState.value = Reducers.addActivityTypes(appState.value, activityTypes);
    return true;
  }

  static Future removeActivityTypes(AppStateObservable appState, List<ActivityType> activityTypes) async {
    var activities = <Activity>[];
    for (ActivityType type in activityTypes) {
      activities.addAll(appState.value.activities.where((a) => a.typeId == type.id).toList());
      await LocalDb().remove(type);
    }
    await removeActivities(appState, activities);    
    appState.value = Reducers.removeActivityTypes(appState.value, activityTypes);
    return [activityTypes, activities];
  }

  static Future<bool> changeActivityType(AppStateObservable appState, ActivityType newType) async {
    if (newType.params.keys.length < 1 || newType.name == '') return false;
    await LocalDb().update(newType);
    appState.value = Reducers.changeActivityType(appState.value, newType);
    return true;
  }

  // because this will mostly be used for restoring activity types
  static Future insertActivityType(AppStateObservable appState, ActivityType type, int idx) async {
    await LocalDb().add(type);  // should change to insert when we get a proper DB
    appState.value = Reducers.insertActivityType(appState.value, type, idx);
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
            base: activity.data['start'] ?? activity.data['end'],
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
    return activities;
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
      await Future.wait<void>(old.data['notis']
        .where((Noti noti) => !newIds.contains(noti.id))
        .map<Future<void>>((Noti noti) => noti.cancel(notiPlug))
      );
      await Future.wait<void>(newActivity.data['notis']
        .where((Noti noti) => !oldIds.contains(noti.id))
        .map<Future<void>>((Noti noti) =>
          noti.schedule(
            notiPlug: notiPlug,
            typeName: typeName,
            channel: newActivity.typeId.toString(),
            base: newActivity.data[poi],
          )
        )
      );
    }
    appState.value = Reducers.changeActivity(appState.value, newActivity);
  }

  // because this will mostly be used for restoring activities  
  static Future insertActivity(AppStateObservable appState, Activity activity, int idx) async {
    await LocalDb().add(activity);  // should change to insert when we get a proper DB
    appState.value = Reducers.insertActivity(appState.value, activity, idx);
  }

  static Future<void> sortActivities(
    AppStateObservable appState,
    { String layout, Map<String, dynamic> options}
  ) async {
    Map<String, dynamic> wholeOptions = appState.value.homeOptions;
    if (options != null) wholeOptions[layout ?? appState.value.homeLayout] = options;
    final prefs = await SharedPrefs.getInstance();
    await prefs.setString('homeOptions', json.encode(wholeOptions));
    appState.value = Reducers.sortActivities(
      appState.value,
      wholeOptions[layout ?? 'list'],
    );
  }

  static void setFocused(AppStateObservable appState, { int index, Activity activity, ActivityType activityType }) {
    appState.value = Reducers.setFocused(appState.value, index, activity, activityType);
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
        () => editor.copyWith(entries: [ MapEntry(param, value ?? validParams[param]) ]));
    } else if (editor is ActivityType) {
      appState.value = Reducers.inlineEditChange(
        appState.value,
        ActivityType,
        () => ActivityType(
          name: name ?? editor.name,
          icon: icon ?? editor.icon,
          color: color ?? editor.color,
          params: params ?? editor.params.keys.toList(),
        )
      );
    }
  }

  static void clearEditing(AppStateObservable appState, dynamic clearing) {
    appState.value = Reducers.clearEditing(appState.value, clearing);
  }

  static Future setTheme(AppStateObservable appState, String themeName) async {
    return SharedPrefs.getInstance()
      .then((prefs) => prefs.setString('theme', themeName))
      .then((_) => appState.value = Reducers.setTheme(appState.value, themes[themeName]));
  }

  static Future focusOnDay(AppStateObservable appState, DateTime day) async {
    return SharedPrefs.getInstance()
      .then((prefs) => prefs.setString('focusedDate', Converters.dateTimeToString(day)))
      .then((_) => appState.value = Reducers.focusOnDay(appState.value, day));
  }

  static Future applyFilter(AppStateObservable appState, String filter, SaveFilter saveFilter) async {
    appState.value = Reducers.saveFilter(appState.value, filter, saveFilter());
    await SharedPrefs.getInstance()
      .then((prefs) => prefs.setJson('filters', appState.value.filters));
  }

}
