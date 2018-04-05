import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ActivityDataInput.dart';

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
        : new Activity(type: stateVal.activityTypes[0]);
    
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text(stateVal.focused >= 0
            ? stateVal.activities[stateVal.focused].data['name']
            : WatoplanLocalizations.of(context).newActivity),
      ),
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ActivityDataInput(
              activity: tmpActivity,
              field: 'name',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        onPressed: () {
          Intents.setFocused(Provider.of(context), stateVal.focused + 1);
        },
      ),
    );
  }
}
