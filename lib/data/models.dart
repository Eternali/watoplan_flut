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


class Param {
  final String name;
  final Object type;
  const Param(this.name, this.type);

  @override
  int get hashCode => name.hashCode + type.hashCode;
}

// const Map<String, Param> VALID_PARAMS = const {
//   'name': const Param('name', String),
//   'desc': const Param('desc', String),
//   'tags': const Param('tags', List),
//   'color': const Param('color', Color),
//   'icon': const Param('icon', IconData),
//   'datetime': const Param('datetime', DateTime),
//   'location': const Param('location', String),
// };
const Map<String, Object> VALID_PARAMS = const {
  'name': String,
  'desc': String,
  'tags': List,
  'color': Color,
  'icon': IconData,
  'datetime': DateTime,
  'location': String,
};

class TypeParam extends Param {
  final bool isOptional;

  const TypeParam({
    String name,
    Object type,
    this.isOptional
  }) : super(name, type);
  TypeParam.ext({
    Param parent,
    this.isOptional
  }) : super(parent.name, parent.type);

  @override
  int get hashCode => isOptional.hashCode + super.hashCode;
}

class ActivityType {

  final String name;
  final converters;
  final Map<String, Object> params;

  ActivityType(this.name, {
    this.params,
    this.converters = const Converters()
  }) {
    params.forEach((name, type) {
      if (!(VALID_PARAMS.keys.contains(name) && VALID_PARAMS[name] == type))
        throw new Exception('$name is not a valid parameter');
    });
  }

  // @override
  // int get hashCode => name.hashCode + params.hashCode;

}

class Activity {

  final ActivityType type;
  Map<String, Object> data;

  Activity({
    this.type,
    this.data
  }) {
    if (data == null) {
      data = type.params;
    } else {
      data.forEach((String name, Object value) {
        int idx = type.params.keys.toList().indexOf(name);
        type.params.values.toList()[0];
        if (idx < 0)
          throw new Exception('$name is not a parameter of ${type.name}');
        else if (value.runtimeType != type.params[name])
          throw new Exception('$name is not a valid parameter for ${type.name}');
      });
      // var paramNames = type.params.map((TypeParam param) => param.name).toList();
      // data.forEach((String name, Object value) {
      //   if (!paramNames.contains(name))
      //     throw new Exception('$name is not a parameter of ${type.name}');
      //   else if (value == type.params[paramNames.indexOf(name)].type)
      //     throw new Exception('$name is not a valid parameter for ${type.name}');          
      // });
    }

    // List<String> typeParamNames = type.params
    //   .where((TypeParam tp) => !tp.isOptional)//.toList()
    //   .map((TypeParam tp) => tp.name).toList();
    // var requiredParamTypes = type.params.where((TypeParam tp) => !tp.isOptional).toList();
    // data.forEach((String name, Object value) {
    //   if (!typeParamNames.contains(name)) {
    //     throw new Exception('$name is not a parameter for ${type.name}');
    //   } else if (value.runtimeType != type.params[typeParamNames.indexOf(name)].type.runtimeType) {
    //     throw new Exception('$name is not a valid parameter for ${type.name}');        
    //   }
    // });
  }

  // @override
  // int get hashCode => type.hashCode + data.hashCode;

}

