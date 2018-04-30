import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';

class EditNotification extends StatefulWidget {

  final Noti noti;
  final Activity activity;
  int timeBefore;

  EditNotification({ this.noti, this.activity }) {
    if (activity.data.containsKey('start')) {
      timeBefore = ((activity.data['start'].millisecondsSinceEpoch - noti.when.millisecondsSinceEpoch) / 60000).round();  // minutes
    } else if (activity.data.containsKey('end')) {
      timeBefore = ((activity.data['end'].millisecondsSinceEpoch - noti.when.millisecondsSinceEpoch) / 60000).round();  // minutes
    }
  }

  @override
  State<EditNotification> createState() => new EditNotificationState();

}

class EditNotificationState extends State<EditNotification> {

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Text(
            '${widget.timeBefore.toString()} minutes before as ${widget.noti.type.name.toLowerCase()}',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () { widget.activity.data['notis'].remove(noti); },
        ),
      ],
    );
  }

}
