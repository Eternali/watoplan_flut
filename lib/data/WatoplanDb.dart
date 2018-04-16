import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:watoplan/data/Converters.dart';
import 'package:watoplan/data/models.dart';

class WatoplanDb {
  
  final String loc;
  Db _db;

  DbCollection typeCollection;
  DbCollection activityCollection;

  WatoplanDb(this.loc) {
    _db = new Db(loc);
  }

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

  Future<bool> update({ ActivityType activityType, Activity activity }) async {
  
  }

}
