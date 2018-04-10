import 'package:flutter/material.dart';

import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/data/models.dart';

class Reducers {

  static AppState addActivityTypes(AppState oldState, List<ActivityType> toadd) {
    AppState newState = new AppState.from(oldState);
    newState.activityTypes.addAll(toadd);

    return newState;
  }

  static AppState removeActivityTypes(AppState oldState, {List<int> indices = const [], List<ActivityType> activityTypes = const []}) {
    AppState newState = new AppState.from(oldState);
    if (indices.length > 0) {
      for (int indice in indices)
        newState.activityTypes.removeAt(indice);
    } else if (activityTypes.length > 0) {
      for (ActivityType activityType in activityTypes)
        newState.activityTypes.remove(activityType);
    }

    return newState;    
  }

  static AppState changeActivityType(AppState oldState, int indice, ActivityType newType) {
    AppState newState = new AppState.from(oldState);
    newState.activityTypes[indice] = ActivityType.from(newType);  // newType;

    return newState;
  }

  static AppState addActivities(AppState oldState, List<Activity> toadd) {
    AppState newState = new AppState.from(oldState);
    newState.activities.addAll(toadd);

    return newState;    
  }

  static AppState removeActivities(AppState oldState,
      {List<int> indices = const [], List<Activity> activities = const []}) {
    AppState newState = new AppState.from(oldState);
    if (indices.length > 0) {
      for (int indice in indices)
        newState.activities.removeAt(indice);
    } else if (activities.length > 0) {
      for (Activity activity in activities)
        newState.activities.remove(activity);
    }

    return newState;    
  }

  static AppState changeActivity(AppState oldState, int indice, Activity newActivity) {
    AppState newState = new AppState.from(oldState);
    newState.activities[indice] = Activity.from(newActivity);

    return newState;
  }

  static AppState setFocused(AppState oldState, int indice, Activity activity, ActivityType activityType) {
    // we can't use AppState.from since focused is a single layer final field.
    return new AppState(
      activities: oldState.activities,
      activityTypes: oldState.activityTypes,
      focused: indice ?? oldState.activities.indexOf(activity) ?? oldState.activityTypes.indexOf(activityType),
      theme: oldState.theme,
    );
  }

  static AppState setTheme(AppState oldState, ThemeData theme) {
    // we can't use AppState.from since theme is final.
    return new AppState(
      activities: oldState.activities,
      activityTypes: oldState.activityTypes,
      focused: oldState.focused,
      theme: theme,
    );
  }

}
