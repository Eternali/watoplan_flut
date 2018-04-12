import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ActivityDataInput.dart';
import 'package:watoplan/widgets/ColorPicker.dart';

class AddEditScreen extends StatefulWidget {

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    var stateVal = Provider.of(context).value;

    Activity tmpActivity = stateVal.focused >= 0
      ? Activity.from(stateVal.activities[stateVal.focused])
      : new Activity(type: stateVal.activityTypes[-(stateVal.focused + 1)], data: {});
    
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor:  tmpActivity.type.color,
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
                child: ActivityDataInput(
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
            tmpActivity.data.containsKey('tags')
              ? new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: new ,
              ) : null,
            tmpActivity.data.containsKey('datetime')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 16.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new MaterialButton(
                      padding: new EdgeInsets.all(12.0),
                      child: new Text(
                        '${(tmpActivity.data['datetime'] as DateTime).hour.toString().padLeft(2, '0')}:'
                        '${(tmpActivity.data['datetime'] as DateTime).minute.toString().padLeft(2, '0')}',
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: new TimeOfDay.fromDateTime(tmpActivity.data['datetime']),
                        ).then(
                          (picked) {
                            if (picked != null) {
                              tmpActivity.data['datetime'].hour = picked.hour;
                              tmpActivity.data['datetime'].minute = picked.minute;
                            }
                          }
                        );
                      },
                    ),
                    new Expanded(child: new Container()),
                    new MaterialButton(
                      padding: new EdgeInsets.all(12.0),
                      child: new Text(
                        '${(tmpActivity.data['datetime'] as DateTime).day.toString().padLeft(2, '0')}/'
                        '${(tmpActivity.data['datetime'] as DateTime).month.toString().padLeft(2, '0')}/'
                        '${(tmpActivity.data['datetime'] as DateTime).year.toString()}',
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: tmpActivity.data['datetime'],
                          firstDate: new DateTime(2013, 1),
                          lastDate: new DateTime(2100),
                        ).then(
                          (picked) {
                            if (picked != null)
                              tmpActivity.data['datetime'] = picked;
                          }  
                        );
                      },
                    ),
                    new Expanded(child: new Container()),
                  ],
                )
              ) : null,
            tmpActivity.data.containsKey('location')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Container(),                
              ) : null,
          ].where((it) => it != null).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        backgroundColor: tmpActivity.type.color,
        onPressed: () {
          if (stateVal.focused < 0) {
            Intents.setFocused(Provider.of(context), indice: stateVal.activities.length);
            Intents.addActivities(Provider.of(context), [tmpActivity]);
          } else {
            Intents.changeActivity(Provider.of(context), stateVal.focused, tmpActivity);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
