import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

class Reducers {

  static AppState set({ List<ActivityType> activityTypes, List<Activity> activities, int focused, ThemeData theme, String sorter, bool sortRev }) {
    return new AppState(
      activityTypes: activityTypes,
      activities: activities,
      focused: focused,
      theme: theme,
      sorter: sorter,
      sortRev: sortRev,
    );
  }

  static AppState addActivityTypes(AppState oldState, List<ActivityType> toadd) {
    AppState newState = new AppState.from(oldState);
    newState.activityTypes.addAll(toadd);

    return newState;
  }

  static AppState removeActivityTypes(AppState oldState, List<ActivityType> activityTypes) {
    AppState newState = new AppState.from(oldState);
    for (ActivityType activityType in activityTypes) newState.activityTypes.remove(activityType);

    return newState;    
  }

  static AppState changeActivityType(AppState oldState, ActivityType newType) {
    AppState newState = new AppState.from(oldState);
    newState.activityTypes[
      newState.activityTypes.map(
        (type) => type.id
      ).toList().indexOf(newType.id)
    ] = ActivityType.from(newType);  // newType;

    return newState;
  }

  static AppState addActivities(AppState oldState, List<Activity> toadd) {
    AppState newState = new AppState.from(oldState);
    newState.activities.addAll(toadd);

    return newState;    
  }

  static AppState removeActivities(AppState oldState, List<Activity> activities) {
    AppState newState = new AppState.from(oldState);
    for (Activity activity in activities) newState.activities.remove(activity);

    return newState;    
  }

  static AppState changeActivity(AppState oldState, Activity newActivity) {
    AppState newState = new AppState.from(oldState);
    newState.activities[
      newState.activities.map(
        (activity) => activity.id
      ).toList().indexOf(newActivity.id)
    ] = Activity.from(newActivity);

    return newState;
  }

  static AppState sortActivities(AppState oldState, String sorterName, [ bool reversed = false ]) {
    return oldState.copyWith(
      activities: validSorts[sorterName](oldState.activities, reversed),
      sorter: sorterName,
      sortRev: reversed,
    );
  }

  static AppState setFocused(AppState oldState, int indice, Activity activity, ActivityType activityType) {
    return oldState.copyWith(
      focused: indice ?? oldState.activities.indexOf(activity) ?? oldState.activityTypes.indexOf(activityType),
    );
  }

  static AppState setTheme(AppState oldState, ThemeData theme) {
    return oldState.copyWith(
      theme: theme,
    );
  }

  static AppState removeTags(AppState oldState, Activity activity, List<int> indices) {
  
  }

}
