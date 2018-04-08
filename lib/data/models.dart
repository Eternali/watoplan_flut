import 'package:flutter/material.dart';

import 'package:watoplan/data/converters.dart';


class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;
  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;

  AppState({this.activities, this.activityTypes, this.focused});
  factory AppState.from(AppState prev) {
    // watch out for reference copies of parameters
    return new AppState(
      activities: prev.activities,
      activityTypes: prev.activityTypes,
      focused: prev.focused
    );
  }

  @override
  int get hashCode => activities.hashCode + activityTypes.hashCode + focused.hashCode;

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
final Map<String, Object> VALID_PARAMS = {
  'name': '',
  'desc': '',
  'tags': [],
  'datetime': new DateTime.now(),
  'location': '',
};

class ActivityType {

  final String name;
  final IconData icon;
  final Color color;
  final Map<String, Object> params;
  final converters;

  ActivityType({
    this.name,
    this.icon,
    this.color,
    this.params,
    this.converters = const Converters()
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
      converters: prev.converters,
    );
  }

}

class Activity {

  final ActivityType type;
  Map<String, Object> data;

  Activity({
    this.type,
    Map<String, Object> data
  }) {
    Map<String, Object> tmpData = new Map.from(type.params);

    data.forEach((String name, Object value) {
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

}

