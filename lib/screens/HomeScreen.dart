import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ActivityCard.dart';

class HomeScreen extends StatelessWidget {

  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateVal = Provider.of(context).value;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title ?? WatoplanLocalizations.of(context).appTitle),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        children: <Widget>[
          new ActivityCard(0)
          // new Text(stateVal.activities[0].data['name'])
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: WatoplanLocalizations.of(context).addActivity,
        child: new Icon(Icons.add),
        onPressed: () {
          Provider.of(context).value += 1;
        },
      ),
    );
  }
}
