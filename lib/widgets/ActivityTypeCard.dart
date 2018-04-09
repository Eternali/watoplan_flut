import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

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
          title: new Text(data.name),
          subtitle: new Text(
            data.params.toString()
          ),
        )
      ),
    );
  }

}

