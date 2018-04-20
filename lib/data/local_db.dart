import 'dart:async';
import 'dart:convert';
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

  factory LocalDb([ String loc = '' ]) {
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

    List<ActivityType> activityTypes = [];
    List<Activity> activities = [];

    _db.readAsString()
      .then((contents) => json.decode(contents))
      .then((decoded) { JsonEncoder encoder = new JsonEncoder.withIndent('  '); print(encoder.convert(decoded)); return decoded; })
      .then((parsed) {
        parsed['activityTypes'].forEach(
          (type) { activityTypes.add(new ActivityType.fromJson(type)); }
        );
        parsed['activities'].forEach(
          (activity) { activities.add(new Activity.fromJson(activity, activityTypes)); }
        );
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

  Future<void> saveOver(List<ActivityType> activityTypes, List<Activity> activities) async {
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
    var data = await load();
    if (item is Activity) {
      data[0][data[0].map((activity) => activity.id).toList().indexOf(item.id)] = item.toJson();
    } else if (item is ActivityType) {
      data[1][data[1].map((type) => type.id).toList().indexOf(item.id)] = item.toJson();
    }
    await saveOver(data[0], data[1]);
  }

  Future<void> add(dynamic item) async {
    var data = await load();
    if (item is Activity) {
      data[0].add(item.toJson());
    } else if (item is ActivityType) {
      data[1].add(item.toJson());
    }
    await saveOver(data[0], data[1]);
  }

  Future<void> remove(dynamic item) async {
    var data = await load();   
    if (item is Activity) {
      data[0].removeAt(
        data[0].map((activity) => activity.id).toList().indexOf(item.id)
      );
    } else if (item is ActivityType) {
      data[1].removeAt(
        data[1].map((type) => type.id).toList().indexOf(item.id)
      );
    }
    await saveOver(data[0], data[1]);   
  }

}
