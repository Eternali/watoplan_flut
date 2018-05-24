import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

typedef T EditingModifier<T>();

class Reducers {

  static AppState initData(
    AppState oldState,
    { List<ActivityType> activityTypes, List<Activity> activities }) {
    return oldState.copyWith(
      activityTypes: activityTypes,
      activities: activities,
    );
  }

  static AppState refresh(AppState oldState) {
    return oldState.copyWith(needsRefresh: false);
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

  static AppState insertActivityType(AppState oldState, ActivityType type, int idx) {
    AppState newState = new AppState.from(oldState);
    newState.activityTypes.insert(idx, type);

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

  static AppState insertActivity(AppState oldState, Activity activity, int idx) {
    AppState newState = new AppState.from(oldState);
    newState.activities.insert(idx, activity);

    return newState;
  }

  static AppState sortActivities(AppState oldState, { String sorterName, bool reversed = false }) {
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

  static AppState editEditing(AppState oldState, dynamic editing) {
    return editing == null
      ? oldState.copyWith(editingActivity: null, editingType: null)
      : editing is Activity
        ? oldState.copyWith(editingActivity: editing)
        : oldState.copyWith(editingType: editing);
  }

  // This is a very loose state modifier, it is only okay because we don't
  // really care how the editing values (editingActivity and editingType) are being
  // modified since they are really only temporary value containers.
  static AppState inlineEditChange(AppState oldState, dynamic editing, EditingModifier modifier) {
    if (editing is! Activity && editing is! ActivityType)
      throw new Exception('Inline editing value must be an Activity or ActivityType');
    return editing is Activity
      ? oldState.copyWith(editingActivity: modifier())
      : oldState.copyWith(editingType: modifier());
  }

  // should make more general to support clearing of any state field
  static AppState clearEditing(AppState oldState, dynamic clearing) {
    return clearing is Activity
      ? oldState.copyWith(editingActivity: null)
      : oldState.copyWith(editingType: null);
  }

  static AppState setTheme(AppState oldState, ThemeData theme) {
    return oldState.copyWith(
      theme: theme,
    );
  }

  static AppState removeTags(AppState oldState, Activity activity, List<int> indices) {
  
  }

}
