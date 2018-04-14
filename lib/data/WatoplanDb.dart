import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/models.dart';

class WatoplanDb {
  
  final String loc;
  Db _db;

  List<ActivityType> activityTypes;
  List<Activity> activities;

  WatoplanDb(this.loc) {
    _db = new Db(loc);
  }

  Future<bool> load() async =>
    _db.open()
      .then((success) {
        if (!success) return false;
        DbCollection typeCollection = _db.collection('activityTypes');
        DbCollection activityCollection = _db.collection('activities');
        
        return true;
      });

  void save() {

  }

}
