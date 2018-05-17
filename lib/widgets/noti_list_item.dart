import 'package:flutter/material.dart';

import 'package:watoplan/keys.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiListItem extends StatefulWidget {

  Noti noti;
  final Activity activity;
  final Function editor;

  String get toi => activity.data.containsKey('start') ? 'start' : 'end';  // time of interest
  int get idx => activity.data['notis'].indexOf(noti);
  TimeBefore get timeBefore => TimeBefore.getProper(
    noti.when.millisecondsSinceEpoch,
    activity.data[toi].millisecondsSinceEpoch,
  );

  NotiListItem({ this.noti, this.activity, this.editor });

  @override
  State<NotiListItem> createState() => new NotiListItemState();

}

class NotiListItemState extends State<NotiListItem> {

  @override
  Widget build(BuildContext context) {
  final state = Provider.of(context);

    return new InkWell(
      onTap: () {
        showDialog<List>(
          context: context,
          builder: (BuildContext context) => new NotiEditDialog(
            type: widget.noti.type,
            timeBefore: widget.timeBefore,
            isNew: false,
          ),
        ).then((List tmb) {  // time and milliseconds before
          if (tmb != null) {
            widget.activity.data['notis'][widget.idx] = widget.noti.copyWith(
              type: tmb[0],
              when: DateTime.fromMillisecondsSinceEpoch(widget.activity.data[widget.toi].millisecondsSinceEpoch - tmb[1])
            );
            widget.editor(
              state,
              widget.activity.copyWith(
                entries: [ MapEntry('notis', widget.activity.data['notis']) ]
              )
            );
            // widget.noti.type = tmb[0];
            // widget.noti.when = new DateTime.fromMillisecondsSinceEpoch(widget.activity.data[widget.toi].millisecondsSinceEpoch - tmb[1]);
          }
        });
      },
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              '${widget.timeBefore.time} ${widget.timeBefore.unit.key}${widget.timeBefore.time.abs() != 1 ? 's' : ''} '
              'before as ${widget.noti.type.name.toLowerCase()}',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.clear),
            onPressed: () {
              widget.editor(
                state,
                widget.activity.copyWith(entries: [ MapEntry('notis', widget.activity.data['notis']..remove(widget.noti)) ])
              );
            }
          ),
        ],
      ),
    );
  }

}
