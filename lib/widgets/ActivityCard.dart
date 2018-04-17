import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';

class ActivityCard extends StatelessWidget {

  final Activity activity;
  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;
    ActivityType tmpType = stateVal.activityTypes.firstWhere((type) => type.id == activity.typeId);

    return new Card(
      color: tmpType.color,
      elevation: 6.0,
      child: new ListTile(
        leading: new Icon(tmpType.icon),
        isThreeLine: true,
        title: new Text(activity.data['name']),
        subtitle: new Text(activity.data['desc']),
        // trailing: new Icon(Icons.check),
        onTap: () {
          Intents.setFocused(Provider.of(context), activity: activity);
          Navigator.of(context).pushNamed(Routes.addEditActivity);
        },
      ),
    );
  }

}