import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/noti.dart';

class NotiEditDialog extends StatefulWidget {

  int before = 30;

  @override
  State<NotiEditDialog> createState() => new NotiEditDialogState();

}

class NotiEditDialogState extends State<NotiEditDialog> {

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: new EdgeInsets.all(0.0),
      content: new Container(
        width: 50.0,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              WatoplanLocalizations.of(context).newNoti
            ),
            new TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() { widget.before = int.parse(value); });
              },
            ),
            new ListView(
              children: <Widget>[
                new Text('Minutes'),
                new Expanded(),
                new Icon(Icons.check),
              ],
            )
          ],
        ),
      ),
    );
  }

}
