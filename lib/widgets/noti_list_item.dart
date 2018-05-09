import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiListItem extends StatefulWidget {

  Noti noti;
  final Activity activity;
  TimeBefore timeBefore;
  final VoidCallback remove;

  NotiListItem({ this.noti, this.activity, this.remove }) {
    if (activity.data.containsKey('start')) {
      timeBefore = TimeBefore.getProper(
        activity.data['start'].millisecondsSinceEpoch,
        noti.when.millisecondsSinceEpoch
      );
    } else if (activity.data.containsKey('end')) {
      timeBefore = TimeBefore.getProper(
        activity.data['end'].millisecondsSinceEpoch,
        noti.when.millisecondsSinceEpoch
      );
    }
  }

  @override
  State<NotiListItem> createState() => new NotiListItemState();

}

class NotiListItemState extends State<NotiListItem> {

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        showDialog<Noti>(
          context: context,
          child: new NotiEditDialog(
            noti: widget.noti,
            timeBefore: widget.timeBefore,
          ),
        ).then((Noti n) {
          if (n != null)
            setState(() {
              widget.noti = n;
            });
        });
      },
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              '${widget.timeBefore.time} ${widget.timeBefore.unit.key}${widget.timeBefore.time > 1 ? 's' : ''} '
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
