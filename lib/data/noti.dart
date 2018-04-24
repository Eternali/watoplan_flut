import 'package:watoplan/data/converters.dart';
import 'package:watoplan/utils/data_utils.dart';

enum NotiTypes { PUSH, EMAIL, TEXT }

typedef DateTime NextTimeGenerator(DateTime last);

class Noti {

  final int _id;
  int get id => _id;
  final String title;
  final String msg;
  DateTime when;
  final NextTimeGenerator generateNext;

  Noti({ int id, this.title, this.msg, this.when, this.generateNext }) : _id = id ?? generateId();

  factory Noti.fromJson(Map<String, dynamic> jsonMap) {
    return new Noti(
      title: jsonMap['title'],
      msg: jsonMap['msg'],
      when: Converters.dateTimeFromString(jsonMap['when']),

    );
  }

  Map<String, dynamic> toJson() {

  }

}
