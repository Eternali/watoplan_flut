import 'dart:math';

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

  final ThemeData theme;
  final String email;

  final bool needsRefresh;

  final String homeLayout;
  final Map<String, Map<String, dynamic>> homeOptions;

  AppState({
    this.activities,
    this.activityTypes,
    this.editingActivity,
    this.editingType,
    this.focused,
    this.theme,
    this.homeLayout,
    this.homeOptions,
    this.needsRefresh = false,
  });
  factory AppState.from(AppState prev) {
    // NOTE: watch out for reference copies of parameters
    return new AppState(
      activities: prev.activities,
      activityTypes: prev.activityTypes,
      editingActivity: prev.editingActivity,
      editingType: prev.editingType,
      focused: prev.focused,
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

  /// This will return a new AppState object with the same attributes as the old one, changing only what is specified.
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
    return new AppState(
      activities: activities ?? this.activities,
      activityTypes: activityTypes ?? this.activityTypes,
      editingActivity: editingActivity ?? this.editingActivity,
      editingType: editingType ?? this.editingType,
      focused: focused ?? this.focused,
      theme: theme ?? this.theme,
      needsRefresh: needsRefresh ?? this.needsRefresh,
      homeLayout: homeLayout ?? this.homeLayout,
      homeOptions: homeOptions ?? (optionOverrides != null ? overrideOptions(this.homeOptions, optionOverrides) : this.homeOptions),
    );
  }

  @override
  int get hashCode => activities.hashCode
                    + activityTypes.hashCode
                    + editingActivity.hashCode
                    + editingType.hashCode
                    + focused.hashCode
                    + theme.hashCode
                    + homeLayout.hashCode
                    + homeOptions.hashCode
                    + needsRefresh.hashCode;

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
  'start': new DateTime.now(),
  'end': new DateTime.now(),
  'notis': <Noti>[],
  'location': new Location(lat: 0.0, long: 0.0),
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
        throw new Exception('$name is not a valid parameter');
      else if (type.runtimeType != validParams[name].runtimeType)
        throw new Exception('${type.runtimeType} is! ${validParams[name].runtimeType}: $name is not a supported type of parameter');
    });
  }

  factory ActivityType.from(ActivityType prev) {
    return new ActivityType(
      id: prev.id,
      name: prev.name,
      icon: prev.icon,
      color: prev.color,
      params: new Map.from(prev.params),
    );
  }

  factory ActivityType.fromJson(Map<String, dynamic> jsonMap) {
    return new ActivityType(
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
  }) => new ActivityType(
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
// is immutable, a new object gets generated with similar properties, but this breaks its reference to activities,
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
      tmpData = new Map.from(type.params);
      data.forEach((String name, dynamic value) {
        int idx = tmpData.keys.toList().indexOf(name);
        if (idx < 0)
          throw new Exception('$name is not a parameter of ${type.name}');
        else if (value.runtimeType != tmpData[name].runtimeType)
          throw new Exception('$name is not a valid parameter for ${type.name}');
        else
          tmpData[name] = value;
      });
    } else throw new Exception('dynamic type parameter must be an int or an ActivityType');

    this.data = tmpData;
  }

  factory Activity.from(Activity prev) {
    return new Activity(
      id: prev.id,
      type: prev.typeId,
      data: prev.data.map((name, value) =>
        // Thanks to dart, I can't do any sort of dynamic typing from variables (which I only have to because of its bad type inferencing)
        new MapEntry(name, value is List<Noti>
          ? new List<Noti>.from(value) : value is Map
            ? new Map.from(value) : value)
      ),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    return new Activity(
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
    Activity newActivity = new Activity(
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

  @override
  int get hashCode => id.hashCode + typeId.hashCode + data.hashCode;

}

