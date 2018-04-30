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

  NotiType type;
  int timeBefore;
  int _timeUnit;
  int get timeUnit => _timeUnit;
  set timeUnit(int setTo) {
    if (TimeUnit.values.contains(setTo)) _timeUnit = setTo;
    else throw Exception('$timeUnit is not a valid value of TimeUnit');
  }

  NotiEditDialog({ this.type, this.timeBefore, timeUnit })
     : _timeUnit = timeUnit;

  @override
  State<NotiEditDialog> createState() => new NotiEditDialogState();

}

class NotiEditDialogState extends State<NotiEditDialog> {

  TextEditingController _controller;

  bool timeActive(int desired) => widget.timeUnit == desired;
  bool typeActive(NotiType desired) => widget.type == desired;

  @override
  initState() {
    super.initState();
    _controller = new TextEditingController(text: '10')
      ..addListener(() => widget.timeBefore = int.parse(_controller.value.text));
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
                name: 'Minutes',
                active: timeActive(TimeUnit['minute']),
                onTap: () { setState(() { widget.timeUnit = TimeUnit['minute']; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'Hours',
                active: timeActive(TimeUnit['hour']),
                onTap: () { setState(() { widget.timeUnit = TimeUnit['hour']; }); },
                theme: theme,
              ),
              checkedItem(
                name: 'Days',
                active: timeActive(TimeUnit['day']),
                onTap: () { setState(() { widget.timeUnit = TimeUnit['day']; }); },
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
          onPressed: () {
            Navigator.pop(
              context,
              {'type': widget.type, 'timeUnit': widget.timeUnit, 'timeBefore': widget.timeBefore }
            );
          },
        )
      ],
    );
  }

}
