import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/widgets/noti_list_item.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiList extends StatefulWidget {

  final Activity activity;

  String get toi => activity.data.containsKey('start') ? 'start' : 'end';  // time of interest

  NotiList(this.activity);

  @override
  State<NotiList> createState() => new NotiListState();

}

class NotiListState extends State<NotiList> {

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        widget.activity.data['notis'].length > 0
          ? new Column(
              children: (widget.activity.data['notis'] as List<Noti>).map(
                (noti) => new NotiListItem(
                  noti: noti,
                  activity: widget.activity,
                  remove: () {
                    setState(() {
                      widget.activity.data['notis'].remove(noti);
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
              child: new NotiEditDialog(
                // noti: new Noti(
                //   title: widget.activity.data['name'],
                //   msg: widget.activity.data['desc'],
                //   when: new DateTime.fromMillisecondsSinceEpoch(
                //     widget.activity.data.containsKey('start')
                //       ? widget.activity.data['start'].millisecondsSinceEpoch - TimeUnits[0].value * 10
                //       : widget.activity.data['end'].millisecondsSinceEpoch - TimeUnits[0].value * 10
                //   ),
                //   type: NotiTypes['PUSH'],
                // ),
                type: NotiTypes['PUSH'],
                timeBefore: new TimeBefore(
                  time: 10,
                  unit: TimeUnits[0],
                ),
              ),
            ).then((List tmb) {  // time and milliseconds before
              print(tmb.toString());
              if (tmb != null)
                setState(() {
                  widget.activity.data['notis'].add(new Noti(
                    title: widget.activity.data['name'],
                    msg: widget.activity.data['desc'],
                    when: new DateTime.fromMillisecondsSinceEpoch(widget.activity.data[widget.toi].millisecondsSinceEpoch - tmb[1]),
                    type: tmb[0],
                  ));
                });
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
              ),
            ],
          ),
        )
      ].where((it) => it != null).toList(),
    );
  }

}

