import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:watoplan/data/converters.dart';
import 'package:watoplan/utils/data_utils.dart';

class TimeBefore {
  int time;
  MapEntry<String, int> unit;
  int get millis => time * unit.value;
  TimeBefore({ this.time, this.unit }) {
    if (!TimeUnits.contains(unit))
      throw Exception('${unit.key} is not a supported unit of time');
  }

  factory TimeBefore.getProper(int before, [ int after ]) {
    int diff = after == null ? before : after - before;
    MapEntry<String, int> unit = TimeUnits[0];

    TimeUnits.forEach((tunit) {
      if (diff / tunit.value >= 1) {
        unit = tunit;
      }
    });

    return TimeBefore(time: (diff / unit.value).round(), unit: unit);
  }
}

const List<MapEntry<String, int>> TimeUnits = [
  const MapEntry('minute', 60000),
  const MapEntry('hour', 60 * 60000),
  const MapEntry('day', 24 * 60 * 60000),
];


class NotiType {
  final String name;
  final Function notify;
  NotiType(this.name, this.notify);
}

Map<String, NotiType> NotiTypes = {
  'PUSH': NotiType('PUSH', () {  }),
  'EMAIL': NotiType('EMAIL', () {  }),
  'SMS': NotiType('SMS', () {  }),
};

typedef DateTime NextTimeGenerator(DateTime last);

class Noti {

  final int _id;
  int get id => _id;
  final String title;
  final String msg;
  final DateTime when;
  final int offset;
  final NotiType type;
  final NextTimeGenerator generateNext;

  /**
   * Notifications are scheduled according to either an absolute time (when) or an offset (millis).
   * If using an offset, when the notification is scheduled, a base DateTime must be provided to offset from.
   */
  Noti({ int id, this.title, this.msg, this.when, this.offset, this.type, this.generateNext }) : _id = id ?? generateId();

  /**
   * Schedules the notification according to its type. If base is specified, the notification offset will be used,
   * otherwise, it is assumed that this has a 'when' property defined.
   */
  Future<void> schedule({
    FlutterLocalNotificationsPlugin notiPlug, 
    String typeName,
    String smsAddr,
    String channel,
    DateTime base,
  }) async {
    switch (type.name) {
      case 'PUSH':
        NotificationDetails platformSpecifics = NotificationDetails(
          AndroidNotificationDetails(
            channel ?? id.toString(),
            typeName ?? 'WAToPlan',
            'Notifications regarding activities of type $typeName',
          ),
          IOSNotificationDetails(),
        );
        await notiPlug.schedule(id, title, msg,
          base == null ? when : DateTime.fromMillisecondsSinceEpoch(base.millisecondsSinceEpoch - offset),
          platformSpecifics
        );
        break;
      case 'EMAIL':

        break;
      case 'SMS':

        break;
    }
  }

  Future<void> cancel(FlutterLocalNotificationsPlugin notiPlug) async {
    await notiPlug.cancel(id);
  }

  factory Noti.fromJson(Map<String, dynamic> jsonMap) {
    return Noti(
      id: jsonMap['_id'],
      title: jsonMap['title'],
      msg: jsonMap['msg'],
      when: jsonMap['when'].length < 1 ? null : Converters.dateTimeFromString(jsonMap['when']),
      offset: int.tryParse(jsonMap['offset']),
      type: NotiTypes[jsonMap['type']],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'title': title,
    'msg': msg,
    'when': when == null ? '' : Converters.dateTimeToString(when),
    'offset': offset.toString() ?? '',
    'type': type.name,
  };

  Noti copyWith({
    int id,
    String title,
    String msg,
    DateTime when,
    int offset,
    NotiType type,
    NextTimeGenerator generateNext,
  }) => Noti(
    id: id ?? this._id,
    title: title ?? this.title,
    msg: msg ?? this.msg,
    when: when ?? this.when,
    offset: offset ?? this.offset,
    type: type ?? this.type,
    generateNext: generateNext ?? this.generateNext,
  );

}
