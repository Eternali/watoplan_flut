import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';

typedef String ActivatableString(bool active);

Widget checkedItem({ ActivatableString name, bool active, VoidCallback onTap, ThemeData theme }) {
  return new InkWell(
    onTap: onTap,
    child: new Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: new Row(
        children: <Widget>[
          new Text(
            name(active),
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

  Noti noti;
  TimeBefore timeBefore;
  NotiType type;

  NotiEditDialog({ this.noti, this.timeBefore }) {
    type = noti.type;
  }

  @override
  State<NotiEditDialog> createState() => new NotiEditDialogState();

}

class NotiEditDialogState extends State<NotiEditDialog> {

  TextEditingController _controller;

  bool timeActive(MapEntry<String, int> desired) => widget.timeBefore.unit == desired;
  bool typeActive(NotiType desired) => widget.type == desired;

  @override
  initState() {
    super.initState();
    _controller = new TextEditingController(text: '10')
      ..addListener(() => widget.timeBefore.reduced = int.parse(_controller.value.text));
  }

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
                  controller: _controller,
                ),
              ),
              checkedItem(
                name: (active) => 'Minutes ${active ? 'before' : ''}',
                active: timeActive(TimeUnits[0]),
                onTap: () { setState(() { widget.timeBefore.unit = TimeUnits[0]; }); },
                theme: theme,
              ),
              checkedItem(
                name: (active) => 'Hours ${active ? 'before' : ''}',
                active: timeActive(TimeUnits[1]),
                onTap: () { setState(() { widget.timeBefore.unit = TimeUnits[1]; }); },
                theme: theme,
              ),
              checkedItem(
                name: (active) => 'Days ${active ? 'before' : ''}',
                active: timeActive(TimeUnits[2]),
                onTap: () { setState(() { widget.timeBefore.unit = TimeUnits[2]; }); },
                theme: theme,
              ),
              new Divider(),
              checkedItem(
                name: (_) => 'as Notification',
                active: typeActive(NotiTypes['PUSH']),
                onTap: () { setState(() { widget.type = NotiTypes['PUSH']; }); },
                theme: theme,
              ),
              checkedItem(
                name: (_) => 'as Email',
                active: typeActive(NotiTypes['EMAIL']),
                onTap: () { setState(() { widget.type = NotiTypes['EMAIL']; }); },
                theme: theme,
              ),
              checkedItem(
                name: (_) => 'as SMS',
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
          onPressed: () {
            Navigator.pop(
              context,
              new Noti(
                id: widget.noti.id,
                title: widget.noti.title,
                msg: widget.noti.title,
                when: new DateTime.fromMillisecondsSinceEpoch(widget.noti.when.millisecondsSinceEpoch - widget.timeBefore.millis),
                type: widget.type,
                generateNext: widget.noti.generateNext,
              ),
            );
          },
        )
      ],
    );
  }

}
