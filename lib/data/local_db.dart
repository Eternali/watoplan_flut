import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

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

  factory LocalDb(String loc) {
    if (_self == null) {
      _self = new LocalDb._init(loc);
    }

    return _self;
  }

  LocalDb._init(loc) {
    _db = new File(loc);
  }

  void destroy() {
    _db = null;
    _self = null;
  }

  Future<List<List<dynamic>>> load() async {

    List<ActivityType> activityTypes;
    List<Activity> activities;

    _db.readAsString()
      .then((contents) => json.decode(contents))
      .then((parsed) {
        List<Map<String, dynamic>> encodedTypes = parsed['activityTypes'];
        List<Map<String, dynamic>> encodedActivities = parsed['activities'];
        
        activityTypes = encodedTypes.map(
          (type) => new ActivityType.fromJson(type)
        ).toList();
        activities = encodedActivities.map(
          (activity) => new Activity.fromJson(activity, activityTypes)
        ).toList();
      });

    return [activityTypes, activities];
  }

  Future<dynamic> loadContaining(MapEntry toFind, { dynamic type }) async {
    int start = 0;
    int end = null;

    if (type is Activity) {
      start = activityCollection.start;
      end = activityCollection.end;
    } else if (type is ActivityType) {
      start = typeCollection.start;
      end = typeCollection.end;
    }

    _db.openRead(start, end);
  }

  Future<bool> saveOver(List<ActivityType> activityTypes, List<Activity> activities) async {
    await _db.writeAsString(
      json.encode({
        'activityTypes': activityTypes.map((type) => type.toJson()).toList(),
        'activities': activities.map((activity) => activity.toJson()).toList(),
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
    if (item is Activity) {

    } else if (item is ActivityType) {

    }
  }

  Future<void> add(dynamic item) async {
    if (item is Activity) {
      var data = load();
      
    } else if (item is ActivityType) {

    }
  }

  Future<void> remove(dynamic item) async {
    if (item is Activity) {

    } else if (item is ActivityType) {

    }
  }

}
