import 'package:flutter/material.dart';

import 'package:watoplan/keys.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/noti_list_item.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiList extends StatefulWidget {

  final Activity activity;

  NotiList(this.activity);

  @override
  State<NotiList> createState() => new NotiListState(activity: activity);

}

class NotiListState extends State<NotiList> {

  final Activity activity;
  String get toi => activity.data.containsKey('start') ? 'start' : 'end';  // time of interest
  
  NotiListState({ this.activity });

  @override
  initState() {
    super.initState();
    debugPrint('\ninitState\n');
  }

  @override
  dispose() {
    debugPrint('\ndispose\n');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        activity.data['notis'].length > 0
          ? new Column(
              children: (activity.data['notis'] as List<Noti>).map(
                (noti) => new NotiListItem(
                  noti: noti,
                  activity: activity,
                  remove: () {
                    setState(() {
                      activity.data['notis'].remove(noti);
                    });
                  },
                )
              ).fold(
                [new Divider()],
                (acc, ele) => new List.from(acc)..addAll([ele, new Divider()])
              ),
            )
          : null,
        new InkWell(
          onTap: () {
            showDialog<List>(
              context: context,
              builder: (BuildContext context) => new NotiEditDialog(
                type: NotiTypes['PUSH'],
                timeBefore: new TimeBefore(
                  time: 15,
                  unit: TimeUnits[0],
                ),
                isNew: true,
              ),
            ).then((List tmb) {  // time and milliseconds before
              if (tmb != null) {
                activity.data['notis'].add(new Noti(
                  title: activity.data['name'],
                  msg: activity.data['desc'],
                  when: new DateTime.fromMillisecondsSinceEpoch(activity.data[toi].millisecondsSinceEpoch - tmb[1]),
                  type: tmb[0],
                ));
              }
            });
          },
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  WatoplanLocalizations.of(context).addNotification,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.add),
                onPressed: null,
              ),
            ],
          ),
        ),
      ].where((it) => it != null).toList(),
    );
  }

}

