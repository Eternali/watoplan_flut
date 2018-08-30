import 'dart:math';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
// import 'package:contact_finder/contact_finder.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/location.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/utils/activity_sorters.dart';
import 'package:watoplan/utils/data_utils.dart';


typedef dynamic OnCall(List);

class VarargsFunction extends Function {
  OnCall _onCall;

  VarargsFunction(this._onCall);

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}


final Map<String, ActivitySort> validSorts = {
  'start': ActivitySorters.byStartTime,
  'end': ActivitySorters.byEndTime,
  'priority': ActivitySorters.byPriority,
  'progress': ActivitySorters.byProgress,
  'type': ActivitySorters.byType,
};

class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;

  // these are only for the add/edit screens because state stored in the widgets is
  // being corrupted (reset) too much (and unexpectedly).
  final Activity editingActivity;
  final ActivityType editingType;

  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;
  // for calendar views
  final DateTime focusedDate;

  final ThemeData theme;
  // final String email;

  final bool needsRefresh;

  final String homeLayout;
  final Map<String, Map<String, dynamic>> homeOptions;

  // Getters
  List<Activity> activitiesOn([DateTime day]) {
    day ??= focusedDate;
    return day == null ? [] : activities
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
  List<Activity> get timeSensitive => activities.where(
      (Activity a) => a.data.values.where((v) => v is DateTime).isNotEmpty
    ).toList();

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
    Map<String, dynamic> optionOverrides
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
    );
  }

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
    needsRefresh.hashCode;

}

class AppStateObservable extends ValueNotifier {
  AppStateObservable(AppState value) : super(value);
}


class MenuChoice {
  final String title;
  final IconData icon;
  final String route;  
  const MenuChoice({
    this.title,
    this.icon,
    this.route,
  });
}


// this workaround is required because apparently [].runtimeType != List
// even though ''.runtimeType == String, and print('${[].runtimeType}') => List
final Map<String, dynamic> validParams = {
  'name': '',
  'desc': '',
  'long': '',
  'priority': 0,
  'progress': 0,
  'start': DateTime.now(),
  'end': DateTime.now(),
  'notis': <Noti>[],
  'location': Location(lat: 0.0, long: 0.0),
  // 'contacts': <Contact>[],
  // 'tags': <String>[],
};

class ActivityType {

  final int _id;
  int get id => _id;
  String name;
  IconData icon;
  Color color;
  Map<String, dynamic> params;

  ActivityType({
    int id,
    this.name = '',
    this.icon = const IconData(0),
    this.color = const Color(0xffaaaaaa),
    this.params,
  }) : _id = id ?? generateId() {
    params ??= {  };
    params.forEach((name, type) {
      if (!validParams.keys.contains(name))
        throw Exception('$name is not a valid parameter');
      else if (type.runtimeType != validParams[name].runtimeType)
        throw Exception('${type.runtimeType} is! ${validParams[name].runtimeType}: $name is not a supported type of parameter');
    });
  }

  factory ActivityType.from(ActivityType prev) {
    return ActivityType(
      id: prev.id,
      name: prev.name,
      icon: prev.icon,
      color: prev.color,
      params: Map.from(prev.params),
    );
  }

  factory ActivityType.fromJson(Map<String, dynamic> jsonMap) {
    return ActivityType(
      id: jsonMap['_id'],
      name: jsonMap['name'],
      icon: Converters.iconFromString(jsonMap['icon']),
      color: Converters.colorFromString(jsonMap['color']),
      params: Converters.paramsFromJson(jsonMap['params']),
    );
  }

  ActivityType copyWith({
    int id,
    String name,
    IconData icon,
    Color color,
    Map<String, dynamic> params,
  }) => ActivityType(
    id: id ?? this._id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    params: params ?? this.params,
  );

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'name': name,
    'icon': Converters.iconToString(icon),
    'color': Converters.colorToString(color),
    'params': Converters.paramsToJson(params),
  };

  @override
  int get hashCode => id.hashCode + name.hashCode + icon.hashCode + color.hashCode + params.hashCode;

}

// NOTE: I am only storing the ActivityType id because this way I don't need a
// reference to the same exact object all the time (when an activityType changes, since everything
// is immutable, a object gets generated with similar properties, but this breaks its reference to activities,
// since a activityType's id never changes, an activity can always have an unbroken reference to its type).
class Activity {

  final int _id;
  int get id => _id;
  int typeId;
  Map<String, dynamic> data;

  Activity({
    int id,
    dynamic type,
    Map<String, dynamic> data
  }) : _id = id ?? generateId() {
    Map<String, dynamic> tmpData;
    if (type is int) {
      typeId = type;
      tmpData = data;
    } else if (type is ActivityType) {
      typeId = type.id;
      tmpData = Map.from(type.params);
      data.forEach((String name, dynamic value) {
        int idx = tmpData.keys.toList().indexOf(name);
        if (idx < 0)
          throw Exception('$name is not a parameter of ${type.name}');
        else if (value.runtimeType != tmpData[name].runtimeType)
          throw Exception('$name is not a valid parameter for ${type.name}');
        else
          tmpData[name] = value;
      });
    } else throw Exception('dynamic type parameter must be an int or an ActivityType');

    this.data = tmpData;
  }

  factory Activity.from(Activity prev) {
    return Activity(
      id: prev.id,
      type: prev.typeId,
      data: prev.data.map((name, value) =>
        // Thanks to dart, I can't do any sort of dynamic typing from variables (which I only have to because of its bad type inferencing)
        MapEntry(name, value is List<Noti>
          ? List<Noti>.from(value) : value is Map
            ? Map.from(value) : value)
      ),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    return Activity(
      id: jsonMap['_id'],
      type: jsonMap['typeId'],
      data: Converters.paramsFromJson(jsonMap['data']),
    );
  }

  Activity copyWith({
    int id,
    dynamic type,
    Map<String, dynamic> data,
    List<MapEntry<String, dynamic>> entries,
  }) {
    Activity newActivity = Activity(
      id: id ?? this._id,
      type: type ?? this.typeId,
      data: data ?? this.data,
    );
    entries.forEach((entry) { newActivity.data[entry.key] = entry.value; });

    return newActivity;
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'typeId': typeId,
    'data': Converters.paramsToJson(data),
  };

  ActivityType getType(List<ActivityType> types) => types.firstWhere((type) => type.id == typeId);

  @override
  int get hashCode => id.hashCode + typeId.hashCode + data.hashCode;

}

