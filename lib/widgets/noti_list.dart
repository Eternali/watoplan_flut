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
  State<NotiList> createState() => NotiListState();

}

class NotiListState extends State<NotiList> {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        widget.activity.data['notis'].length > 0
          ? Column(
              children: (widget.activity.data['notis'] as List<Noti>).map(
                (noti) => NotiListItem(
                  noti: noti,
                  activity: widget.activity,
                  editor: widget.editor,
                )
              ).fold(
                [new Divider()],
                (acc, ele) => List.from(acc)..addAll([ele, Divider()])
              ),
            )
          : null,
        InkWell(
          onTap: () {
            showDialog<List>(
              context: context,
              builder: (BuildContext context) => NotiEditDialog(
                type: NotiTypes['PUSH'],
                timeBefore: TimeBefore(
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
                      Noti(
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  WatoplanLocalizations.of(context).addNotification,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: null,
              ),
            ],
          ),
        ),
      ].where((it) => it != null).toList(),
    );
  }

}

