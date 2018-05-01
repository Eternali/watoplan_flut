import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class EditNotification extends StatefulWidget {

  Noti noti;
  final Activity activity;
  TimeBefore timeBefore;
  final VoidCallback remove;

  EditNotification({ this.noti, this.activity, this.remove }) {
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
  State<EditNotification> createState() => new EditNotificationState();

}

class EditNotificationState extends State<EditNotification> {

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
              print(n.toJson());
              widget.noti = n;
            });
        });
      },
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              '${widget.timeBefore.time.toString()} minutes before as ${widget.noti.type.name.toLowerCase()}',
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
