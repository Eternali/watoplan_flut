import 'package:flutter/material.dart';

import 'package:watoplan/keys.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/noti_list_item.dart';
import 'package:watoplan/widgets/noti_edit_dialog.dart';

class NotiList extends StatefulWidget {

  final Activity activity;
  final Function editor;

  String get toi => activity.data.containsKey('start') ? 'start' : 'end';  // time of interest  

  NotiList({ this.activity, this.editor});

  @override
  State<NotiList> createState() => new NotiListState();

}

class NotiListState extends State<NotiList> {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of(context);

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        widget.activity.data['notis'].length > 0
          ? new Column(
              children: (widget.activity.data['notis'] as List<Noti>).map(
                (noti) => new NotiListItem(
                  noti: noti,
                  activity: widget.activity,
                  editor: widget.editor,
                )
              ).fold(
                [new Divider()],
                (acc, ele) => new List.from(acc)..addAll([ele, new Divider()])
              ),
            )
          : null,
        new InkWell(
          onTap: () {
            showDialog<List>(
              context: context,
              builder: (BuildContext context) => new NotiEditDialog(
                type: NotiTypes['PUSH'],
                timeBefore: new TimeBefore(
                  time: 10,
                  unit: TimeUnits[0],
                ),
                isNew: true,
              ),
            ).then((List tmb) {  // type and milliseconds before
              if (tmb != null) {
                widget.editor(
                  state,
                  widget.activity.copyWith(
                    entries: [ MapEntry('notis', widget.activity.data['notis']..add(
                      new Noti(
                        title: widget.activity.data['name'],
                        msg: widget.activity.data['desc'],
                        offset: tmb[1],
                        type: tmb[0],
                      )
                    )) ]
                  )
                );
              }
            });
          },
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  WatoplanLocalizations.of(context).addNotification,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.add),
                onPressed: null,
              ),
            ],
          ),
        ),
      ].where((it) => it != null).toList(),
    );
  }

}

