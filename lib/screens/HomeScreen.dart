import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/widgets/ActivityCard.dart';
import 'package:watoplan/widgets/FAM.dart';

class HomeScreen extends StatelessWidget {

  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateVal = Provider.of(context).value;

    List<SubFAB> typesToSubFABS(List<ActivityType> types) {
      return types.map(
        (it) => new SubFAB(
          icon: it.params['icon'],
          color: it.params['color'],
          onPressed: () {
            Intents.setFocused(Provider.of(context), -1);
            Navigator.of(context).pushNamed(Routes.addEditActivity);
          },
        )
      ).toList();
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title ?? WatoplanLocalizations.of(context).appTitle),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        children: new Iterable.generate(stateVal.activities.length)
          .map((it) => new ActivityCard(it)).toList()
      ),
      floatingActionButton: new FloatingActionMenu(
        color: Colors.amber,
        width: 56.0,
        height: 70.0,
        entries: typesToSubFABS(stateVal.activityTypes),
      ),
    );
  }
}
