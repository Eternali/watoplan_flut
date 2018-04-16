import 'dart:convert' show JSON;

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

  String name;
  IconData icon;
  Color color;
  Map<String, dynamic> params;

  ActivityType({
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
  }

  factory ActivityType.from(ActivityType prev) {
    return new ActivityType(
      name: prev.name,
      icon: prev.icon,
      color: prev.color,
      params: new Map.from(prev.params),
    );
  }

  ActivityType.fromJson(String json) {
    var parsed = JSON.decode(json);
    name = parsed['name'];
    icon = Converters.iconFromString(parsed['icon']);
    color = Converters.colorFromHex(parsed['color']);
    params = Converters.paramsFromJson(parsed['params']);
  }

  @override
  String toString() {
    return name +
      Converters.iconToString(icon) +
      Converters.colorToString(color);
      // Converters.paramsToJson(params);
  }

}

class Activity {

  ActivityType type;
  Map<String, dynamic> data;

  Activity({
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
  }

  factory Activity.from(Activity prev) {
    return new Activity(
      type: prev.type,
      data: new Map.from(prev.data),
    );
  }

  Activity.fromJson(String json) {
    var parsed = JSON.decode(json);
    type = new ActivityType.fromJson(parsed['type']);
    data = Converters.paramsFromJson(parsed['data']);
  }



}

