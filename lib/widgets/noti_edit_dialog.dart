import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';

Widget checkedItem({ String name, bool active, VoidCallback onTap, ThemeData theme }) {
  return new InkWell(
    onTap: onTap,
    child: new Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: new Row(
        children: <Widget>[
          new Text(
            name,
            style: new TextStyle(
              color: active ? theme.accentColor : theme.textTheme.subhead.color
            ),
          ),
          new Expanded(child: new Container()),
          active ? new Icon(Icons.check, color: theme.accentColor) : new Icon(new IconData(0)),
        ],
      ),
    ),
  );
}

class NotiEditDialog extends StatefulWidget {

  final Noti noti;
  final Activity activity;
  int timeUnit = 0;
  NotiType type = NotiTypes['PUSH'];

  NotiEditDialog({ noti, this.activity, int when })
     : noti = noti ?? new Noti(
         title: activity.data['name'],
         msg: activity.data['desc'] ?? 'Your time\'s up!',
         when: DateTime.fromMillisecondsSinceEpoch(when),
       );

  @override
  State<NotiEditDialog> createState() => new NotiEditDialogState();

}

class NotiEditDialogState extends State<NotiEditDialog> {

  bool timeActive(int desired) => widget.timeUnit == desired;
  bool typeActive(NotiType desired) => widget.type == desired;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return new AlertDialog(
      contentPadding: new EdgeInsets.all(0.0),
      title: new Center(
        child: new Text(WatoplanLocalizations.of(context).newNoti),
      ),
      content: new SingleChildScrollView(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          child: new ListBody(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() { });  // widget.activity = int.parse(value); });
                  },
                ),
              ),
              checkedItem(
                name: 'Minutes',
                active: timeActive(0),
                onTap: () { setState(() { widget.timeUnit = 0; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'Hours',
                active: timeActive(1),
                onTap: () { setState(() { widget.timeUnit = 1; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'Days',
                active: timeActive(2),
                onTap: () { setState(() { widget.timeUnit = 2; }); },
                theme: theme,
              ),
              new Divider(),
              checkedItem(
                name: 'as Notification',
                active: typeActive(NotiTypes['PUSH']),
                onTap: () { setState(() { widget.type = NotiTypes['PUSH']; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'as Email',
                active: typeActive(NotiTypes['EMAIL']),
                onTap: () { setState(() { widget.type = NotiTypes['EMAIL']; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'as SMS',
                active: typeActive(NotiTypes['SMS']),
                onTap: () { setState(() { widget.type = NotiTypes['SMS']; }); },
                theme: theme,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text(
            WatoplanLocalizations.of(context).cancel,
            style: new TextStyle(
              color: theme.accentColor,
            ),
          ),
          onPressed: () { Navigator.pop(context, null); },
        ),
        new FlatButton(
          child: new Text(
            WatoplanLocalizations.of(context).save,
            style: new TextStyle(
              color: theme.accentColor,
            ),
          ),
          onPressed: () { Navigator.pop(context); },
        )
      ],
    );
  }

}
