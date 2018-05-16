import 'package:flutter/material.dart';

import 'package:watoplan/keys.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiListItem extends StatefulWidget {

  Noti noti;
  final Activity activity;
  final VoidCallback remove;

  String get toi => activity.data.containsKey('start') ? 'start' : 'end';  // time of interest
  TimeBefore get timeBefore => TimeBefore.getProper(
    noti.when.millisecondsSinceEpoch,
    activity.data[toi].millisecondsSinceEpoch,
  );

  NotiListItem({ this.noti, this.activity, this.remove });

  @override
  State<NotiListItem> createState() => new NotiListItemState();

}

class NotiListItemState extends State<NotiListItem> {

  @override
  Widget build(BuildContext context) {
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
            widget.noti.type = tmb[0];
            widget.noti.when = new DateTime.fromMillisecondsSinceEpoch(widget.activity.data[widget.toi].millisecondsSinceEpoch - tmb[1]);
            setState(() {  });
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
            onPressed: widget.remove,
          ),
        ],
      ),
    );
  }

}
