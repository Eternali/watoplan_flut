import 'package:flutter/material.dart';

import 'package:watoplan/data/converters.dart';


class AppState {
  final List<Activity> activities;
  final List<ActivityType> activityTypes;  // ACTIVITY, EVENT, MEETING, ASSESSMENT, PROJECT
  final int focused;

  AppState({this.activities, this.activityTypes, this.focused});

  @override
  int get hashCode => activities.hashCode + activityTypes.hashCode + focused.hashCode;

}

class AppStateObservable extends ValueNotifier {
  AppStateObservable(AppState value) : super(value);
}


// this workaround is required because apparently [].runtimeType != List
// even though ''.runtimeType == String, and print('${[].runtimeType}') => List
final Map<String, Object> VALID_PARAMS = {
  'name': '',
  'desc': '',
  'tags': [],
  'color': const Color(0x00000000),
  'icon': Icons.star,
  'datetime': new DateTime.now(),
  'location': '',
};

class ActivityType {

  final String name;
  final converters;
  final Map<String, Object> params;

  ActivityType(this.name, {
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
      // type.params.values.toList()[0];
      if (idx < 0)
        throw new Exception('$name is not a parameter of ${type.name}');
      else if (value.runtimeType != tmpData[name].runtimeType)
        throw new Exception('$name is not a valid parameter for ${type.name}');
      else
        tmpData[name] = value;
    });

    this.data = tmpData;
  }

}

