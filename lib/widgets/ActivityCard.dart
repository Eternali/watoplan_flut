import 'package:flutter/material.dart';

import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/data/models.dart';

class ActivityCard extends StatelessWidget {

  final int idx;
  ActivityCard(this.idx);

  @override
  Widget build(BuildContext context) {

    var state = Provider.of(context);

    return new Card(
      color: Colors.redAccent,
      elevation: 6.0,
      child: new ListTile(
        leading: new Icon(state.activities[idx].data['icon']),
        isThreeLine: true,
        title: new Text('Test'),
        subtitle: new Text('subtitle'),
        trailing: new Icon(Icons.check),
      ),
    );
  }

}