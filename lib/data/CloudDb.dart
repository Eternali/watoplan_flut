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

  void destroy() {
    _watoplandb = null;
  }

  Future<bool> open() => _db.open();

  Future<bool> close() => _db.close();

  Future<bool> load(List<ActivityType> activityTypes, List<Activity> activities) async {
    Map success = {  };

    typeCollection = _db.collection('activityTypes');
    activityCollection = _db.collection('activities');
    
    success = await typeCollection.find().forEach((type) {
      activityTypes.add(new ActivityType.fromJson(type));
    });
    success = await activityCollection.find().forEach((activity) {
      activities.add(new Activity.fromJson(activity, activityTypes));
    });

    return success.isNotEmpty;
  }

  Future<bool> saveOver(List<ActivityType> activityTypes, List<Activity> activities) async {
    bool successDrop = false;
    Map successSave = {  };

    successDrop = await typeCollection.drop();
    successDrop = await activityCollection.drop();
    if (successDrop) {
      successSave = await typeCollection.insertAll(
        activityTypes.map((type) => type.toJson()).toList()
      );
      successSave = await activityCollection.insertAll(
        activities.map((activity) => activity.toJson()).toList()
      );
    }

    return successDrop && successSave.isNotEmpty;
  }

  void clear() async {
    await _db.dropCollection('activityTypes');
    await _db.dropCollection('activities');
  }

  Future<bool> update(dynamic item) async {
    Map success = {  };

    if (item is Activity)
      success = await activityCollection.update(where.eq('_id', item.id), item);
    else if (item is ActivityType)
      success = await typeCollection.update(where.eq('_id', item.id), item);

    return success.isNotEmpty;
  }

  Future<bool> add(dynamic item) async {
    Map success = {  };

    if (item is Activity)
      success = await activityCollection.insert(item.toJson());
    else if (item is ActivityType)
      success = await typeCollection.insert(item.toJson());

    return success.isNotEmpty;
  }

  Future<bool> remove(dynamic item) async {
    Map success = {  };

    if (item is Activity)
      success = await activityCollection.remove(where.eq('_id', item.id));
    else if (item is ActivityType)
      success = await typeCollection.remove(where.eq('_id', item.id));    

    return success.isNotEmpty;
  }

}
