import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/data/models.dart';

class ActivityCard extends StatelessWidget {

  final int idx;
  ActivityCard(this.idx);

  @override
  Widget build(BuildContext context) {

    var state = Provider.of(context).value;

    return new Card(
      color: state.activities[idx].type.color,
      elevation: 6.0,
      child: new ListTile(
        leading: new Icon(state.activities[idx].type.icon),
        isThreeLine: true,
        title: new Text(state.activities[idx].data['name']),
        subtitle: new Text(state.activities[idx].data['desc']),
        // trailing: new Icon(Icons.check),
        onTap: () {
          Intents.setFocused(Provider.of(context), idx);
          Navigator.of(context).pushNamed(Routes.addEditActivity);
        },
      ),
    );
  }

}