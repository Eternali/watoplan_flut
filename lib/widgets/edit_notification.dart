import 'package:flutter/material.dart';

import 'package:watoplan/data/noti.dart';

class EditNotification extends StatefulWidget {

  final Noti noti;

  EditNotification(this.noti);

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
            widget.noti.when.toString(),
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () {  },
        ),
      ],
    );
  }

}
