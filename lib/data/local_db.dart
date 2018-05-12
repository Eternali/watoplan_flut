import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:watoplan/data/models.dart';

class DbCollection {
  int start;
  int end;

  DbCollection({ this.start, this.end });

}

class LocalDb {
  
  static LocalDb _self;

  File _db;
  DbCollection typeCollection;
  DbCollection activityCollection;

  factory LocalDb([ String loc = '' ]) {
    if (_self == null) {
      _self = new LocalDb._init(loc);
    }

    return _self;
  }

  LocalDb._init(loc) {
    _db = new File(loc);
    // _db.createSync();
  }

  void destroy() {
    _db = null;
    _self = null;
  }

  Stream<ActivityType> loadTypes() async* {
    // _db.openRead();
  }

  Stream<Activity> loadActivities(List<ActivityType> types) async* {

  }

  Future<List<List>> loadAtOnce() async {

    List<ActivityType> activityTypes = [];
    List<Activity> activities = [];

    try {
    await _db.readAsString()
      .then((contents) => json.decode(contents))
      .then((parsed) {
        parsed['activityTypes'].forEach(
          (type) { activityTypes.add(new ActivityType.fromJson(type)); }
        );
        parsed['activities'].forEach(
          (activity) { activities.add(new Activity.fromJson(activity, activityTypes)); }
        );
      })
      .catchError((e) { print('The database at ${_db.path} is empty: ${e.error}'); });
    } catch (e) {
      print('The database at ${_db.path} is empty: ${e.error}');
    }

    return [activityTypes, activities];
  }

  Future<dynamic> loadContaining(MapEntry toFind, { dynamic type }) async {
    int start = 0;
    int end;

    if (type is Activity) {
      start = activityCollection.start;
      end = activityCollection.end;
    } else if (type is ActivityType) {
      start = typeCollection.start;
      end = typeCollection.end;
    }

    _db.openRead(start, end);
  }

  Future<void> saveOver(List activityTypes, List activities) async {
    await _db.writeAsString(
      json.encode({
        'activityTypes': activityTypes.map((type) => type is ActivityType ? type.toJson() : type).toList(),
        'activities': activities.map((activity) => activity is Activity ? activity.toJson() : activity).toList(),
      })
    );
  }

  Future<void> clear() async {
    await _db.writeAsString(
      json.encode({
        'activityTypes': [  ],
        'activities': [  ],
      })
    );
  }

  Future<void> update(dynamic item) async {
    var data = await loadAtOnce();
    if (item is ActivityType) {
      data[0][data[0].map((type) => type.id).toList().indexOf(item.id)] = item;
    } else if (item is Activity) {
      data[1][data[1].map((activity) => activity.id).toList().indexOf(item.id)] = item;
    }
    await saveOver(data[0], data[1]);
  }

  Future<void> add(dynamic item) async {
    var data = await loadAtOnce();
    if (item is ActivityType) {
      data[0].add(item);
    } else if (item is Activity) {
      data[1].add(item);
    }
    await saveOver(data[0], data[1]);
  }

  Future<void> remove(dynamic item) async {
    var data = await loadAtOnce();   
    if (item is ActivityType) {
      data[0].removeAt(
        data[0].map((type) => type.id).toList().indexOf(item.id)
      );
    } else if (item is Activity) {
      data[1].removeAt(
        data[1].map((activity) => activity.id).toList().indexOf(item.id)
      );
    }
    await saveOver(data[0], data[1]);   
  }

}
