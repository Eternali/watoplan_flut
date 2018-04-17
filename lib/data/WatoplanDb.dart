import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:watoplan/data/Converters.dart';
import 'package:watoplan/data/models.dart';

class WatoplanDb {
  
  static WatoplanDb _watoplandb;

  final String loc;
  Db _db;

  DbCollection typeCollection;
  DbCollection activityCollection;

  factory WatoplanDb(String loc) =>
    _watoplandb ?? new WatoplanDb._internal(loc);

  WatoplanDb._internal(this.loc) {
    _db = new Db(loc);
  }

  Future<bool> open() => _db.open();

  Future<bool> close() => _db.close();

  Future<bool> load(List<ActivityType> activityTypes, List<Activity> activities) =>
    _db.open()
      .then((success) {
        if (!success) return false;

        typeCollection = _db.collection('activityTypes');
        activityCollection = _db.collection('activities');

        return true;
      });

  Future<bool> save(List<ActivityType> activityTypes, List<Activity> activities) async {
    bool success = await typeCollection.drop();
    if (!success) return false;
    await typeCollection.insertAll(activityTypes.map((type) => type.toJson()).toList());

    success = await activityCollection.drop();
    if (!success) return false;
    await activityCollection.insertAll(activities.map((activity) => activity.toJson()).toList());

    return true;
  }

  Future<bool> clear() async {
  
  }

  Future<bool> update({ ActivityType activityType, Activity activity }) async {
    Map success = {  };

    if (activityType != null) {
      success = await typeCollection.update(where.eq('id', activityType.id), activityType);
    } else if (activity != null) {
      success = await activityCollection.update(where.eq('id', activity.id), activity);
    }

    return success.isNotEmpty;
  }

  Future<bool> add(List<dynamic> items) async {
    Map success = {  };

    if (items is List<Activity>)
      success = await activityCollection.insertAll(
        items.map((activity) => activity.toJson()).toList()
      );
    else if (items is List<ActivityType>)
      success = await typeCollection.insertAll(
        items.map((type) => type.toJson()).toList()
      );

    return success.isNotEmpty;
  }

  Future<bool> remove(List<dynamic> items) async {
    Map success = {  };

    if (items is List<Activity>)
    else if (items is List<ActivityType>)

    return success.isNotEmpty;
  }

}
