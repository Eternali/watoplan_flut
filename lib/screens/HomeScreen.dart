import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/intents.dart';
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
        children: new Iterable.generate(stateVal.activities.length).map((it) => new ActivityCard(it)).toList()
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: WatoplanLocalizations.of(context).addActivity,
        child: new Icon(Icons.add),
        onPressed: () {
          Intents.setFocused(Provider.of(context), -1);
          Navigator.of(context).pushNamed(Routes.addEditActivity);
        },
      ),
    );
  }
}
