import 'package:date_utils/date_utils.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/location.dart';
import 'package:watoplan/data/noti.dart';

typedef TypeInitializer<T>();
typedef T Cloner<T>(T value);

class ParamType<T, U> {

  final String name;
  final T type;
  TypeInitializer<T> init;
  JsonConverter fromJson;
  JsonConverter toJson;
  Cloner<T> cloner;
  Filter<U> filter;

  ParamType(this.name, this.type, {
    this.init,
    this.fromJson,
    this.toJson,
    this.cloner,
    this.filter,
  }) {
    init ??= () => type;
    fromJson ??= (value) => value;
    toJson ??= (value) => value.toString();
    cloner ??= (value) => value;
  }

}

// this workaround is required because apparently [].runtimeType != List
// even though ''.runtimeType == String, and print('${[].runtimeType}') => List
final Map<String, dynamic> validParams = {
  'name': ParamType<String, List<String>>('name', ''),
  'desc': ParamType<String, List<String>>('desc', ''),
  'long': ParamType<String, List<String>>('long', ''),
  'tags': ParamType<List<Tag>, List<String>>(
    'tags',
    <Tag>[],
    init: () => <Tag>[],
    cloner: (t) => List<Tag>.from(t),
    fromJson: (raw) => raw.map<Tag>((r) => Tag.fromJson(r)).toList(),
    toJson: (tags) => tags.map((t) => t.toJson()).toList(),
  ),
  'priority': ParamType<int, List<int>>(
    'priority',
    0,
    fromJson: (v) => v is int ? v : int.parse(v),
  ),
  'progress': ParamType<int, List<int>>(
    'progress',
    0,
    fromJson: (v) => v is int ? v : int.parse(v),
  ),
  'start': ParamType<DateTime, List<DateTime>>(
    'start',
    DateTime.now(),
    init: () => DateTime.now(),
    fromJson: (v) => DateTime.fromMillisecondsSinceEpoch(v is int ? v : int.parse(v)),
    toJson: (v) => v.millisecondsSinceEpoch,
    cloner: (v) => Utils.copyWith(v),
  ),
  'end': ParamType<DateTime, List<DateTime>>(
    'end',
    DateTime.now(),
    init: () => DateTime.now(),
    fromJson: (v) => DateTime.fromMillisecondsSinceEpoch(v is int ? v : int.parse(v)),
    toJson: (v) => v.millisecondsSinceEpoch,
    cloner: (v) => Utils.copyWith(v),
  ),
  'notis': ParamType<List<Noti>, List<NotiType>>(
    'notis',
    <Noti>[],
    init: () => <Noti>[],
    cloner: (v) => List<Noti>.from(v),
    fromJson: (v) => v.map<Noti>((n) => Noti.fromJson(n)).toList(),
    toJson: (v) => v.map((n) => n.toJson()).toList(),
  ),
  'location': ParamType<Location, List<Location>>(
    'location',
    Location(lat: 0.0, long: 0.0),
    init: () => Location(lat: 0.0, long: 0.0),
    fromJson: (v) => Location.fromJson(v),
    toJson: (v) => v.toJson(),
    cloner: (v) => Location(lat: v.lat, long: v.long),
  ),
  // 'contacts': ParamType<List<Contact>>(<Contact>[], init: () => <Contact>[]),
  // 'tags': ParamType<List<String>>(<String>[], init: () => <String>[]),
};
