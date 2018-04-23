import 'dart:math';

import 'package:flutter/material.dart';

import 'package:watoplan/data/converters.dart';


class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;

  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;

  final ThemeData theme;

  AppState({ this.activities, this.activityTypes, this.focused, this.theme });
  factory AppState.from(AppState prev) {
    // NOTE: watch out for reference copies of parameters
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
  'tags': <String>[],
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
    _id = id ?? int.parse(
      DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(10000).toString().padLeft(5, '0')
    );
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
    'color': Converters.colorToString(color),
    'params': Converters.paramsToJson(params),
  };

}

// NOTE: I am only storing the ActivityType id because this way I don't need a
// reference to the same exact object all the time (when an activityType changes, since everything
// is immutable, a new object gets generated with similar properties, but this breaks its reference to activities,
// since a activityType's id never changes, an activity can always have an unbroken reference to its type).
class Activity {

  int _id;
  int get id => _id;
  int typeId;
  Map<String, dynamic> data;

  Activity({
    int id,
    dynamic type,
    Map<String, dynamic> data
  }) {
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
    _id = id ?? int.parse(
      DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(10000).toString().padLeft(5, '0')
    );
  }

  factory Activity.from(Activity prev) {
    return new Activity(
      id: prev.id,
      type: prev.typeId,
      data: new Map.from(prev.data),
    );
  }

  Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    _id = jsonMap['_id'];
    typeId = jsonMap['typeId'];
    data = Converters.paramsFromJson(jsonMap['data']);
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'typeId': typeId,
    'data': Converters.paramsToJson(data),
  };

}

