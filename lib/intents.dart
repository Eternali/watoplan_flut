import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/reducers.dart';
import 'package:watoplan/data/Provider.dart';

class Intents {

  static void addActivityTypes(AppStateObservable appState, List<ActivityType> activityTypes) {
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

  static void addActivities(AppStateObservable appState, List<Activity> activities) {
    appState.value = Reducers.addActivities(appState.value, activities);
  }

  static void removeActivities(AppStateObservable appState,
      {List<int> indices = const [], List<Activity> activities = const []}) {
    if (indices.length > 0)
      appState.value = Reducers.removeActivities(appState.value, indices: indices);    
    else if (activities.length > 0)
      appState.value = Reducers.removeActivities(appState.value, activities: activities);
  }

  static void changeActivity(AppStateObservable appState, int indice, Activity newActivity) {
    appState.value = Reducers.changeActivity(appState.value, indice, newActivity);
  }

  static void setFocused(AppStateObservable appState, int indice) {
    appState.value = Reducers.setFocused(appState.value, indice);
  }

  static void setTheme(AppStateObservable appState, ThemeData theme) {
    appState.value = Reducers.setTheme(appState.value, theme);
  }

}

