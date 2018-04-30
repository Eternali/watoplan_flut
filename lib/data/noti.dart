import 'package:watoplan/data/converters.dart';
import 'package:watoplan/utils/data_utils.dart';

class TimeUnit {
  final String name;
  final int value;
  const TimeUnit(this.name, this.value);
}

class TimeBefore {
  int time;
  Map<String, int> unit;
  TimeBefore({ this.time, unit }) {
    if (TimeUnits.keys.contains(unit)) this.unit = unit;
    else throw Exception('$unit is not a supported unit of time');
  }
}

const Map<String, TimeUnit> TimeUnits = {
  'minute': new TimeUnit('minute', 1),
  'hour': 60,
  'day': 24 * 60,
};

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
