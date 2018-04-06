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
    print(stateVal.focused.toString());
    Activity tmpActivity = stateVal.focused >= 0
        ? Activity.from(stateVal.activities[stateVal.focused])
        : new Activity(type: stateVal.activityTypes[-(stateVal.focused + 1)], data: {});
    
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: tmpActivity.data['color'],
        leading: new BackButton(),
        title: new Text(stateVal.focused >= 0
            ? stateVal.activities[stateVal.focused].data['name']
            : WatoplanLocalizations.of(context).newActivity),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Container(),
              ) : null,
            tmpActivity.data.containsKey('color')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 20.0),
                child: new RaisedButton(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text(
                    'CHOOSE COLOR',
                    style: new TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 1.2,
                    ),
                  ),
                  color: tmpActivity.data['color'],
                  onPressed: () {
                    ColorPicker picker = new ColorPicker(
                      (tmpActivity.data['color'] as Color).red.toDouble(),
                      (tmpActivity.data['color'] as Color).green.toDouble(),
                      (tmpActivity.data['color'] as Color).blue.toDouble());
                    showDialog<Color>(context: context, child: picker)
                      .then((Color c) {
                        if (c != null)
                          setState(() { tmpActivity.data['color'] = c; });
                      });
                  },
                )
              ) : null,
            tmpActivity.data.containsKey('icon')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Container()
              ) : null,
            tmpActivity.data.containsKey('datetime')
              ? new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        'TIME',
                        style: new TextStyle(

                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
                    new RaisedButton(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        'DATE',
                        style: new TextStyle(

                        ),
                      ),
                    ),
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
        backgroundColor: tmpActivity.data['color'],
        onPressed: () {
          Intents.setFocused(Provider.of(context), stateVal.focused + 1);
        },
      ),
    );
  }
}
