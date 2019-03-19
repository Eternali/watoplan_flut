import 'dart:math';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
// import 'package:contact_finder/contact_finder.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/home_layouts.dart';
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

  final Map<String, dynamic> filters;

  // negative values denote activityTypes (-1 = index 0) while zero and positives indicate activities
  final int focused;
  // for calendar views
  final DateTime focusedDate;

  final ThemeData theme;
  // final String email;

  final bool needsRefresh;

  final String homeLayout;
  final Map<String, Map<String, dynamic>> homeOptions;

  /// Getters ///

  List<Activity> activitiesOn([DateTime day]) {
    day ??= focusedDate;
    return day == null ? [] : filteredActivities
      .where((Activity a) {
        if (a.data.containsKey('start') && !a.data.containsKey('end')) {
          return Utils.isSameDay(a.data['start'], day);
        } else if (!a.data.containsKey('start') && a.data.containsKey('end')) {
          return Utils.isSameDay(a.data['end'], day);
        } else if (a.data.containsKey('start') && a.data.containsKey('end')) {
          // accommodates cases where the 'day' is after the activity but still on the same day
          // (shouldn't ever happen, but we should be careful).
          return (Utils.isSameDay(a.data['start'], day) || a.data['start'].isBefore(day)) &&
            (Utils.isSameDay(a.data['end'], day) || a.data['end'].isAfter(day));
        } else {
          return false;
        }
      }).toList();
  }
  
  List<Activity> get filteredActivities {
    return activities.where((Activity a) =>
      filters.entries.fold(true, (bool acc, MapEntry<String, dynamic> f) =>
        validParams.keys.contains(f.key)
          ? validParams[f.key].applyFilter(f.value, a)
          : filterApplicators[f.key](f.value, a)
      )
    ).toList();
  }

  List<Activity> get timeSensitive => activities.where(
      (Activity a) => a.data.values.where((v) => v is DateTime).isNotEmpty
    ).toList();

  AppState({
    this.activities,
    this.activityTypes,
    this.editingActivity,
    this.editingType,
    this.focused,
    this.focusedDate,
    this.theme,
    this.homeLayout,
    this.homeOptions,
    this.needsRefresh = false,
    this.filters = const {},
  });
  factory AppState.from(AppState prev) {
    // NOTE: watch out for reference copies of parameters
    return AppState(
      activities: prev.activities,
      activityTypes: prev.activityTypes,
      editingActivity: prev.editingActivity,
      editingType: prev.editingType,
      focused: prev.focused,
      focusedDate: prev.focusedDate,
      theme: prev.theme,
      homeLayout: prev.homeLayout,
      homeOptions: prev.homeOptions,
      needsRefresh: prev.needsRefresh,
      filters: prev.filters,
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

  /// This will return a AppState object with the same attributes as the old one, changing only what is specified.
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
    DateTime focusedDate,
    ThemeData theme,
    bool needsRefresh,
    String homeLayout,
    Map<String, Map<String, dynamic>> homeOptions,
    Map<String, dynamic> specificOptions,
    Map<String, dynamic> optionOverrides,
    Map<String, dynamic> filters,
  }) {
    if (specificOptions != null) {
      homeOptions ??= this.homeOptions;
      homeOptions[homeLayout ?? this.homeLayout] = specificOptions;
    }
    return AppState(
      activities: activities ?? this.activities,
      activityTypes: activityTypes ?? this.activityTypes,
      editingActivity: editingActivity ?? this.editingActivity,
      editingType: editingType ?? this.editingType,
      focused: focused ?? this.focused,
      focusedDate: focusedDate ?? this.focusedDate,
      theme: theme ?? this.theme,
      needsRefresh: needsRefresh ?? this.needsRefresh,
      homeLayout: homeLayout ?? this.homeLayout,
      homeOptions: homeOptions ?? (optionOverrides != null ? overrideOptions(this.homeOptions, optionOverrides) : this.homeOptions),
      filters: filters ?? this.filters,
    );
  }

  // Static Helpers
  static String safeHomeLayout(String unsafe) => unsafe == null
    ? unsafe
    : validLayouts.values.firstWhere((HomeLayout l) => l.validKeys.contains(unsafe)).name;

  @override
  int get hashCode =>
    activities.hashCode +
    activityTypes.hashCode +
    editingActivity.hashCode +
    editingType.hashCode +
    focused.hashCode +
    focusedDate.hashCode +
    theme.hashCode +
    homeLayout.hashCode +
    homeOptions.hashCode +
    needsRefresh.hashCode +
    filters.hashCode;

}

class AppStateObservable extends ValueNotifier<AppState> {
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


typedef TypeInitializer<T>();
typedef T Cloner<T>(T value);
typedef dynamic JsonConverter(dynamic value);
typedef bool FilterApplicator<T>(T filters, Activity activity);

class ParamType<T, U> {

  final T type;
  TypeInitializer<T> init;
  JsonConverter fromJson;
  JsonConverter toJson;
  Cloner<T> cloner;
  WidgetBuilder filterBuilder;
  FilterApplicator<U> applyFilter;
  JsonConverter filterFromJson;
  JsonConverter filterToJson;

  ParamType(this.type, {
    this.init,
    this.fromJson,
    this.toJson,
    this.cloner,
    this.filterBuilder,
    this.applyFilter,
    this.filterFromJson,
    this.filterToJson,
  }) {
    init ??= () => type;
    fromJson ??= (value) => value;
    toJson ??= (value) => value.toString();
    cloner ??= (value) => value;
    applyFilter ??= (U filters, Activity activity) => true;
    filterFromJson ??= (value) => value;
    filterToJson ??= (value) => value.map((v) => v.toString());
  }

}

final Map<String, FilterApplicator<List>> filterApplicators = {
  'type': (List types, Activity activity) {
    return types.length < 1 || types.contains(activity.typeId);
  }
};

// this workaround is required because apparently [].runtimeType != List
// even though ''.runtimeType == String, and print('${[].runtimeType}') => List
final Map<String, dynamic> validParams = {
  'name': ParamType<String, List<String>>(''),
  'desc': ParamType<String, List<String>>(''),
  'long': ParamType<String, List<String>>(''),
  'priority': ParamType<int, List<int>>(
    0,
    fromJson: (v) => v is int ? v : int.parse(v),
  ),
  'progress': ParamType<int, List<int>>(
    0,
    fromJson: (v) => v is int ? v : int.parse(v),
  ),
  'start': ParamType<DateTime, List<DateTime>>(
    DateTime.now(),
    init: () => DateTime.now(),
    fromJson: (v) => DateTime.fromMillisecondsSinceEpoch(v is int ? v : int.parse(v)),
    toJson: (v) => v.millisecondsSinceEpoch,
    cloner: (v) => Utils.copyWith(v),
  ),
  'end': ParamType<DateTime, List<DateTime>>(
    DateTime.now(),
    init: () => DateTime.now(),
    fromJson: (v) => DateTime.fromMillisecondsSinceEpoch(v is int ? v : int.parse(v)),
    toJson: (v) => v.millisecondsSinceEpoch,
    cloner: (v) => Utils.copyWith(v),
  ),
  'notis': ParamType<List<Noti>, List<NotiType>>(
    <Noti>[],
    init: () => <Noti>[],
    fromJson: (v) => v.map<Noti>((n) => Noti.fromJson(n)).toList(),
    toJson: (v) => v.map((n) => n.toJson()).toList(),
    cloner: (v) => List<Noti>.from(v),
  ),
  'location': ParamType<Location, List<Location>>(
    Location(lat: 0.0, long: 0.0),
    init: () => Location(lat: 0.0, long: 0.0),
    fromJson: (v) => Location.fromJson(v),
    toJson: (v) => v.toJson(),
    cloner: (v) => Location(lat: v.lat, long: v.long),
  ),
  // 'contacts': ParamType<List<Contact>>(<Contact>[], init: () => <Contact>[]),
  // 'tags': ParamType<List<String>>(<String>[], init: () => <String>[]),
};

class ActivityType {

  final int _id;
  int get id => _id;
  final int creation;
  String name;
  IconData icon;
  Color color;
  Map<String, ParamType> params = {  };

  ActivityType({
    int id,
    int creation,
    this.name = '',
    this.icon = const IconData(0),
    this.color = const Color(0xffaaaaaa),
    List<String> params = const [],  // only allowed to pass a list of param names to avoid typing issues
  }) : _id = id ?? generateId(), creation =creation ?? DateTime.now().millisecondsSinceEpoch {
    params.forEach((name) {
      if (!validParams.keys.contains(name))
        throw Exception('$name is not a valid parameter');
      this.params[name] = validParams[name];
    });
  }

  factory ActivityType.from(ActivityType prev) {
    return ActivityType(
      id: prev.id,
      creation: prev.creation,
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
      name: jsonMap['name'],
      icon: Converters.iconFromString(jsonMap['icon']),
      color: Converters.colorFromString(jsonMap['color']),
      params: Converters.paramsFromJson(jsonMap['params']),
    );
  }

  ActivityType copyWith({
    int id,
    int creation,
    String name,
    IconData icon,
    Color color,
    List<String> params,
  }) => ActivityType(
    id: id ?? this._id,
    creation: creation ?? this.creation,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    params: params ?? List<ParamType>.from(this.params.keys),
  );

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'creation': creation,
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
  int get hashCode => id.hashCode + creation.hashCode + name.hashCode + icon.hashCode + color.hashCode + params.hashCode;

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
  Map<String, dynamic> data;

  Activity({
    int id,
    dynamic type,
    int creation,
    Map<String, dynamic> data
  }) : _id = id ?? generateId(), creation = creation ?? DateTime.now().millisecondsSinceEpoch {
    if (type is int) {
      typeId = type;
      this.data = data; 
    } else if (type is ActivityType) {
      typeId = type.id;
      this.data = Map.from(type.params).map((k, v) => MapEntry(k, v.init()));
    } else throw Exception('dynamic type parameter must be an int or an ActivityType');
  }

  factory Activity.from(Activity prev) {
    return Activity(
      id: prev.id,
      type: prev.typeId,
      creation: prev.creation,
      data: Map<String, dynamic>.from(prev.data)
        .map((name, value) => MapEntry(name, validParams[name].cloner(value)))
    );
  }

  factory Activity.fromJson(Map<String, dynamic> jsonMap, List<ActivityType> activityTypes) {
    return Activity(
      id: jsonMap['_id'],
      type: jsonMap['typeId'],
      creation: jsonMap['creation'],
      data: Converters.paramsFromJson(jsonMap['data'], true),
    );
  }

  Activity copyWith({
    int id,
    dynamic type,
    int creation,
    Map<String, dynamic> data,
    List<MapEntry<String, dynamic>> entries,
  }) {
    Activity newActivity = Activity(
      id: id ?? this._id,
      type: type ?? this.typeId,
      creation: creation ?? this.creation,
      data: data ?? Map<String, dynamic>.from(this.data)
        .map((name, value) => MapEntry(name, validParams[name].cloner(value))),
    );
    entries.forEach((entry) { newActivity.data[entry.key] = entry.value; });

    return newActivity;
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'typeId': typeId,
    'creation':creation,
    'data': Converters.paramsToJson(data, true),
  };

  ActivityType getType(List<ActivityType> types) => types.firstWhere((type) => type.id == typeId);

  @override
  int get hashCode => id.hashCode + typeId.hashCode + creation.hashCode + data.hashCode;

}

