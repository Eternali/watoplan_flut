import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_data_input.dart';
import 'package:watoplan/widgets/color_picker.dart';
import 'package:watoplan/widgets/date_time_picker.dart';
import 'package:watoplan/widgets/tag_list_item.dart';
import 'package:watoplan/utils/data_utils.dart';

class AddEditScreen extends StatefulWidget {

  DateTime test = new DateTime.now();

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;

    Activity tmpActivity = stateVal.focused >= 0
      ? new Activity.from(stateVal.activities[stateVal.focused])
      : new Activity(type: stateVal.activityTypes[-(stateVal.focused + 1)], data: {});
    Color activityColor = stateVal.activityTypes.firstWhere((type) => type.id == tmpActivity.typeId).color;
    
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: activityColor,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(stateVal.focused >= 0
          ? stateVal.activities[stateVal.focused].data['name']
          : WatoplanLocalizations.of(context).newActivity
        ),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            tmpActivity.data.containsKey('name')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new ActivityDataInput(
                  activity: tmpActivity,
                  field: 'name',
                )
              ) : null,
            tmpActivity.data.containsKey('desc')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new ActivityDataInput(
                  activity: tmpActivity,
                  field: 'desc',
                )
              ) : null,
            tmpActivity.data.containsKey('datetime')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 16.0),
                child: new DateTimePicker(
                  color: Theme.of(context).disabledColor,
                  when: tmpActivity.data['datetime'],
                  setDate: (date) {
                    tmpActivity.data['datetime'] = date;
                    return tmpActivity.data['datetime'];                    
                  },
                  setTime: (time) {
                     tmpActivity.data['datetime'] = DateTimeUtils.fromTimeOfDay(tmpActivity.data['datetime'], time);
                    return tmpActivity.data['datetime'];
                  },
                )
              ) : null,
            tmpActivity.data.containsKey('location')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Container(),                
              ) : null,
            tmpActivity.data.containsKey('tags')
              ? new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: new TagListItem(0, tmpActivity),
              ) : null,
          ].where((it) => it != null).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        backgroundColor: activityColor,
        onPressed: () {
          if (stateVal.focused < 0) {
            Intents.addActivities(Provider.of(context), [tmpActivity])
              .then((_) { Intents.setFocused(Provider.of(context), indice: stateVal.activities.length - 1); });
          } else {
            Intents.changeActivity(Provider.of(context), stateVal.focused, tmpActivity);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
