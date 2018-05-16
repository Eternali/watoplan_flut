import 'dart:math';

import 'package:flutter/material.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/person.dart';
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
  final String sorter;
  final bool sortRev;

  AppState({
    this.activities,
    this.activityTypes,
    this.editingActivity,
    this.editingType,
    this.focused,
    this.theme,
    this.sorter,
    this.sortRev = false
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
      sorter: prev.sorter,
      sortRev: prev.sortRev,
    );
  }

  AppState copyWith({
    List<Activity> activities,
    List<ActivityType> activityTypes,
    Activity editingActivity,
    ActivityType editingType,
    int focused,
    ThemeData theme,
    String sorter,
    bool sortRev,
  }) {
    return new AppState(
      activities: activities ?? this.activities,
      activityTypes: activityTypes ?? this.activityTypes,
      editingActivity: editingActivity ?? this.editingActivity,
      editingType: editingType ?? this.editingType,
      focused: focused ?? this.focused,
      theme: theme ?? this.theme,
      sorter: sorter ?? this.sorter,
      sortRev: sortRev ?? this.sortRev,
    );
  }

  @override
  int get hashCode => activities.hashCode
                      + activityTypes.hashCode
                      + editingActivity.hashCode
                      + editingType.hashCode
                      + focused.hashCode
                      + theme.hashCode
                      + sorter.hashCode
                      + sortRev.hashCode;

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
  'priority': 0,
  'progress': 0,
  'start': new DateTime.now(),
  'end': new DateTime.now(),
  'notis': <Noti>[],
  'location': '',
  // 'entities': <Person>[],
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
    this.name,
    this.icon,
    this.color,
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

}

