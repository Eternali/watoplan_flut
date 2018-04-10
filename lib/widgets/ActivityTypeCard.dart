import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/intents.dart';

class ActivityTypeCard extends StatelessWidget {

  final ActivityType data;

  ActivityTypeCard(this.data);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Card(
        color: data.color,
        child: new ListTile(
          leading: new Icon(data.icon),
          dense: true,
          title: new Text(
            data.name,
            style: new TextStyle(
              fontSize: 18.0
            ),
          ),
          subtitle: new Text(
            data.params.toString(),
            style: new TextStyle(
              fontSize: 12.0
            ),
          ),
          trailing: new IconButton(
            alignment: Alignment.centerRight,
            icon: new Icon(Icons.clear),
            onPressed: () {
              Intents.removeActivityTypes(
                Provider.of(context),
                activityTypes: [data],
              );
            },
          ),
        )
      ),
    );
  }

}

