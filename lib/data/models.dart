import 'dart:convert' show json;

import 'package:flutter/material.dart';

import 'package:watoplan/data/Converters.dart';


class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;

  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;

  final ThemeData theme;

  AppState({ this.activities, this.activityTypes, this.focused, this.theme });
  factory AppState.from(AppState prev) {
    // watch out for reference copies of parameters
    return new AppState(
      activities: prev.activities,
      activityTypes: prev.activityTypes,
      focused: prev.focused,
      theme: prev.theme,
    );
  }

  @override
  int get hashCode => activities.hashCode + activityTypes.hashCode + focused.hashCode + theme.hashCode;

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
final Map<String, dynamic> VALID_PARAMS = {
  'name': '',
  'desc': '',
  'tags': [],
  'datetime': new DateTime.now(),
  'location': '',
};

class ActivityType {

  int _id;
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
    this.params = const {  },
  }) {
    params.forEach((name, type) {
      if (!VALID_PARAMS.keys.contains(name))
        throw new Exception('$name is not a valid parameter');
      else if (type.runtimeType != VALID_PARAMS[name].runtimeType)
        throw new Exception('$name is not a supported type of parameter');
    });
    _id = id ?? new DateTime.now().millisecondsSinceEpoch;
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

  ActivityType.fromJson(Map<String, dynamic> jsonMap) {
    _id = jsonMap['_id'];
    name = jsonMap['name'];
    icon = Converters.iconFromString(jsonMap['icon']);
    color = Converters.colorFromString(jsonMap['color']);
    params = Converters.paramsFromJson(jsonMap['params']);
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'name': name,
    'icon': Converters.iconToString(icon),
    'colors': Converters.colorToString(color),
    'params': Converters.paramsToJson(params),
  };

}

class Activity {

  int _id;
  int get id => _id;
  ActivityType type;
  Map<String, dynamic> data;

  Activity({
    int id,
    this.type,
    Map<String, dynamic> data
  }) {
    Map<String, dynamic> tmpData = new Map.from(type.params);

    data.forEach((String name, dynamic value) {
      int idx = tmpData.keys.toList().indexOf(name);
      if (idx < 0)
        throw new Exception('$name is not a parameter of ${type.name}');
      else if (value.runtimeType != tmpData[name].runtimeType)
        throw new Exception('$name is not a valid parameter for ${type.name}');
      else
        tmpData[name] = value;
    });

    this.data = tmpData;
    _id = id ?? new DateTime.now().millisecondsSinceEpoch;
  }

  factory Activity.from(Activity prev) {
    return new Activity(
      id: prev.id,
      type: prev.type,
      data: new Map.from(prev.data),
    );
  }

  Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    _id = jsonMap['_id'];
    type = activityTypes.firstWhere((activityType) => activityType.id == jsonMap['typeid']);
    data = Converters.paramsFromJson(jsonMap['data']);
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'typeid': type.id,
    'data': Converters.paramsToJson(data),
  };

}

