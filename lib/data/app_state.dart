import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

import 'package:watoplan/data/activity.dart';
import 'package:watoplan/data/filters.dart';
import 'package:watoplan/data/home_layouts.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/params.dart';

class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;

  // these are only for the add/edit screens because state stored in the widgets is
  // being corrupted (reset) too much (and unexpectedly).
  final Activity editingActivity;
  final ActivityType editingType;

  final Map<String, dynamic> filters;

  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;
  // for calendar views
  final DateTime focusedDate;

  final ThemeData theme;
  // final String email;

  final bool needsRefresh;

  final String homeLayout;
  final Map<String, Map<String, dynamic>> homeOptions;

  /// Getters ///

  List<Activity> activitiesOn([DateTime day]) {
    day ??= focusedDate;
    return day == null ? [] : filteredActivities
      .where((Activity a) {
        if (a.data.containsKey('start') && !a.data.containsKey('end')) {
          return Utils.isSameDay(a.data['start'], day);
        } else if (!a.data.containsKey('start') && a.data.containsKey('end')) {
          return Utils.isSameDay(a.data['end'], day);
        } else if (a.data.containsKey('start') && a.data.containsKey('end')) {
          // accommodates cases where the 'day' is after the activity but still on the same day
          // (shouldn't ever happen, but we should be careful).
          return (Utils.isSameDay(a.data['start'], day) || a.data['start'].isBefore(day)) &&
            (Utils.isSameDay(a.data['end'], day) || a.data['end'].isAfter(day));
        } else {
          return false;
        }
      }).toList();
  }
  
  List<Activity> get filteredActivities {
    return activities.where((Activity a) =>
      filters.entries.fold(true, (bool acc, MapEntry<String, dynamic> f) =>
        validParams.keys.contains(f.key)
          ? validParams[f.key].filter.applyFilter(f.value, a)
          : filterApplicators[f.key].applyFilter(f.value as List, a)
      )
    ).toList();
  }

  List<Activity> get timeSensitive => activities.where(
      (Activity a) => a.data.values.where((v) => v is DateTime).isNotEmpty
    ).toList();

  String get dbpath => LocalDb().path;

  AppState({
    this.activities,
    this.activityTypes,
    this.editingActivity,
    this.editingType,
    this.focused,
    this.focusedDate,
    this.theme,
    this.homeLayout,
    this.homeOptions,
    this.needsRefresh = false,
    this.filters = const {},
  });
  factory AppState.from(AppState prev) {
    // NOTE: watch out for reference copies of parameters
    return AppState(
      activities: prev.activities,
      activityTypes: prev.activityTypes,
      editingActivity: prev.editingActivity,
      editingType: prev.editingType,
      focused: prev.focused,
      focusedDate: prev.focusedDate,
      theme: prev.theme,
      homeLayout: prev.homeLayout,
      homeOptions: prev.homeOptions,
      needsRefresh: prev.needsRefresh,
      filters: prev.filters,
    );
  }

  Map<String, dynamic> overrideOptions(dynamic base, dynamic changes) {
    if (base is! Map) return changes;
    else if (changes is! Map)
      throw Exception('Incompatable types: ${changes.runtimeType} cannot be used to override ${base.runtimeType}.');
    (changes as Map).forEach((key, value) {
      if (!base.containsKey(key)) throw Exception('Changes are not compatible to the base map: $key does not exist.');
      base[key] = overrideOptions(base[key], value);
    });

    return base;
  }

  /// This will return a AppState object with the same attributes as the old one, changing only what is specified.
  /// Note on option parameters: if homeOptions is specified, that will be the only options parameter used,
  /// if specificOptions is specified, it will only change the map entry corresponding to the specified homeLayout,
  /// optionOverrides are used to only change the entries specified (the difference between this and specificOptions is
  /// that specificOptions is used as a shortcut to change entire top level entries of homeOptions, while optionOverrides
  /// can make modifications on a deep Map)
  AppState copyWith({
    List<Activity> activities,
    List<ActivityType> activityTypes,
    Activity editingActivity,
    ActivityType editingType,
    int focused,
    DateTime focusedDate,
    ThemeData theme,
    bool needsRefresh,
    String homeLayout,
    Map<String, Map<String, dynamic>> homeOptions,
    Map<String, dynamic> specificOptions,
    Map<String, dynamic> optionOverrides,
    Map<String, dynamic> filters,
  }) {
    if (specificOptions != null) {
      homeOptions ??= this.homeOptions;
      homeOptions[homeLayout ?? this.homeLayout] = specificOptions;
    }
    return AppState(
      activities: activities ?? this.activities,
      activityTypes: activityTypes ?? this.activityTypes,
      editingActivity: editingActivity ?? this.editingActivity,
      editingType: editingType ?? this.editingType,
      focused: focused ?? this.focused,
      focusedDate: focusedDate ?? this.focusedDate,
      theme: theme ?? this.theme,
      needsRefresh: needsRefresh ?? this.needsRefresh,
      homeLayout: homeLayout ?? this.homeLayout,
      homeOptions: homeOptions ?? (optionOverrides != null ? overrideOptions(this.homeOptions, optionOverrides) : this.homeOptions),
      filters: filters ?? this.filters,
    );
  }

  // Static Helpers
  static String safeHomeLayout(String unsafe) => unsafe == null
    ? unsafe
    : validLayouts.values.firstWhere((HomeLayout l) => l.validKeys.contains(unsafe)).name;

  @override
  int get hashCode =>
    activities.hashCode +
    activityTypes.hashCode +
    editingActivity.hashCode +
    editingType.hashCode +
    focused.hashCode +
    focusedDate.hashCode +
    theme.hashCode +
    homeLayout.hashCode +
    homeOptions.hashCode +
    needsRefresh.hashCode +
    filters.hashCode;

}

class AppStateObservable extends ValueNotifier<AppState> {
  AppStateObservable(AppState value) : super(value);
}