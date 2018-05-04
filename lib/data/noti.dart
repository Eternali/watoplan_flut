import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/notification_details.dart';
import 'package:flutter_local_notifications/platform_specifics/android/notification_details_android.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/notification_details_ios.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/utils/data_utils.dart';

class TimeBefore {
  int time;
  MapEntry<String, int> unit;
  int get realTime => time * unit.value;
  TimeBefore({ this.time, this.unit }) {
    if (!TimeUnits.contains(unit))
      throw Exception('${unit.key} is not a supported unit of time');
  }

  factory TimeBefore.getProper(int before, int after) {
    return new TimeBefore(time: 10, unit: TimeUnits[0]);
  }
}

const List<MapEntry<String, int>> TimeUnits = [
  const MapEntry('minute', 1),
  const MapEntry('hour', 60),
  const MapEntry('day', 24 * 60),
];


class NotiType {
  final String name;
  final Function notify;
  NotiType(this.name, this.notify);
}

Map<String, NotiType> NotiTypes = {
  'PUSH': new NotiType('PUSH', () {  }),
  'EMAIL': new NotiType('EMAIL', () {  }),
  'SMS': new NotiType('SMS', () {  }),
};

typedef DateTime NextTimeGenerator(DateTime last);

class Noti {

  final int _id;
  int get id => _id;
  final String title;
  final String msg;
  DateTime when;
  NotiType type;
  final NextTimeGenerator generateNext;

  Noti({ int id, this.title, this.msg, this.when, this.type, this.generateNext }) : _id = id ?? generateId();

  void schedule(FlutterLocalNotificationsPlugin notiPlug, [ Activity owner, String typeName ]) {
    NotificationDetails platformSpecifics = new NotificationDetails(
      new NotificationDetailsAndroid(
        owner.typeId.toString() ?? id,
        typeName ?? 'WAToPlan',
        'Notifications regarding activities of type $typeName',
      ),
      new NotificationDetailsIOS(),
    );
    notiPlug.schedule(id, title, msg, when, platformSpecifics);
  }

  Future<void> cancel(FlutterLocalNotificationsPlugin notiPlug) async {
    await notiPlug.cancel(id);
  }

  factory Noti.fromJson(Map<String, dynamic> jsonMap) {
    return new Noti(
      id: jsonMap['_id'],
      title: jsonMap['title'],
      msg: jsonMap['msg'],
      when: Converters.dateTimeFromString(jsonMap['when']),
      type: NotiTypes[jsonMap['type']],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'title': title,
    'msg': msg,
    'when': Converters.dateTimeToString(when),
    'type': type.name,
  };

}
