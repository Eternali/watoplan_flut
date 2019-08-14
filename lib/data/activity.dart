import 'package:flutter/material.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/params.dart';
import 'package:watoplan/utils/data_utils.dart';

class ActivityType {

  final int _id;
  int get id => _id;
  final int creation;
  int edited;
  String name;
  IconData icon;
  Color color;
  Map<String, ParamType> params = {  };

  ActivityType({
    int id,
    int creation,
    int edited,
    this.name = '',
    this.icon = const IconData(0),
    this.color = const Color(0xffaaaaaa),
    List<String> params = const [],  // only allowed to pass a list of param names to avoid typing issues
  }) : _id = id ?? generateId(), creation = creation ?? DateTime.now().millisecondsSinceEpoch,
      edited = edited ?? DateTime.now().millisecondsSinceEpoch {
    params.forEach((name) {
      if (!validParams.keys.contains(name))
        throw Exception('$name is not a valid parameter');
      this.params[name] = validParams[name];
    });
  }

  factory ActivityType.from(ActivityType prev, { bool isNew = false }) {
    return ActivityType(
      id: isNew ? null : prev.id,
      creation: prev.creation,
      edited: prev.edited,
      name: prev.name,
      icon: prev.icon,
      color: prev.color,
      params: prev.params.keys.toList(),
    );
  }

  factory ActivityType.fromJson(Map<String, dynamic> jsonMap) {
    return ActivityType(
      id: jsonMap['_id'],
      creation: jsonMap['creation'],
      edited: jsonMap['edited'],
      name: jsonMap['name'],
      icon: Converters.iconFromString(jsonMap['icon']),
      color: Converters.colorFromString(jsonMap['color']),
      params: Converters.paramsFromJson(jsonMap['params']),
    );
  }

  ActivityType copyWith({
    int id,
    int creation,
    int edited,
    String name,
    IconData icon,
    Color color,
    List<String> params,
  }) => ActivityType(
    id: id ?? this._id,
    creation: creation ?? this.creation,
    edited: edited ?? this.edited,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    params: params ?? List<ParamType>.from(this.params.keys),
  );

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'creation': creation,
    'edited': edited,
    'name': name,
    'icon': Converters.iconToString(icon),
    'color': Converters.colorToString(color),
    'params': Converters.paramsToJson(params.keys.toList()),
  };

  Activity createActivity() {
    return Activity(
      type: id,
      data: params.map((key, value) => MapEntry(key, value.init())),
    );
  }

  @override
  int get hashCode => id.hashCode +
    creation.hashCode +
    edited.hashCode +
    name.hashCode +
    icon.hashCode +
    color.hashCode +
    params.hashCode;

}

// NOTE: I am only storing the ActivityType id because this way I don't need a
// reference to the same exact object all the time (when an activityType changes, since everything
// is immutable, a object gets generated with similar properties, but this breaks its reference to activities,
// since a activityType's id never changes, an activity can always have an unbroken reference to its type).
class Activity {

  final int _id;
  int get id => _id;
  int typeId;
  final int creation;
  int edited;
  Map<String, dynamic> data;

  Activity({
    int id,
    dynamic type,
    int creation,
    int edited,
    Map<String, dynamic> data
  }) : _id = id ?? generateId(), creation = creation ?? DateTime.now().millisecondsSinceEpoch,
      edited = edited ?? DateTime.now().millisecondsSinceEpoch {
    if (type is int) {
      typeId = type;
      this.data = data; 
    } else if (type is ActivityType) {
      typeId = type.id;
      this.data = Map.from(type.params).map((k, v) => MapEntry(k, v.init()));
    } else throw Exception('dynamic type parameter must be an int or an ActivityType');
  }

  factory Activity.from(Activity prev, { bool isNew = false }) {
    return Activity(
      id: isNew ? null : prev.id,
      type: prev.typeId,
      creation: prev.creation,
      edited: prev.edited,
      data: Map<String, dynamic>.from(prev.data)
        .map((name, value) => MapEntry(name, validParams[name].cloner(value)))
    );
  }

  factory Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    return Activity(
      id: jsonMap['_id'],
      type: jsonMap['typeId'],
      creation: jsonMap['creation'],
      edited: jsonMap['edited'],
      data: Converters.paramsFromJson(jsonMap['data'], true),
    );
  }

  Activity copyWith({
    int id,
    dynamic type,
    int creation,
    int edited,
    Map<String, dynamic> data,
    List<MapEntry<String, dynamic>> entries,
  }) {
    Activity newActivity = Activity(
      id: id ?? this._id,
      type: type ?? this.typeId,
      creation: creation ?? this.creation,
      edited: edited ?? this.edited,
      data: data ?? Map<String, dynamic>.from(this.data)
        .map((name, value) => MapEntry(name, validParams[name].cloner(value))),
    );
    entries.forEach((entry) { newActivity.data[entry.key] = entry.value; });

    return newActivity;
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'typeId': typeId,
    'creation': creation,
    'edited': edited,
    'data': Converters.paramsToJson(data, true),
  };

  ActivityType getType(List<ActivityType> types) => types.firstWhere((type) => type.id == typeId);

  @override
  int get hashCode => id.hashCode +
    typeId.hashCode +
    creation.hashCode +
    edited.hashCode +
    data.hashCode;

}
