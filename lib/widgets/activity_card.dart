import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';

class ActivityCard extends StatelessWidget {

  final Activity activity;
  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState stateVal = Provider.of(context).value;
    ActivityType tmpType = stateVal.activityTypes.firstWhere((type) => type.id == activity.typeId);

    return new Dismissible(
      key: new Key(activity.id.toString()),
      background: new Container(
        padding: new EdgeInsets.symmetric(horizontal: 14.0),
        child: new Row(
          children: <Widget>[
            new Icon(Icons.delete),
            new Expanded(child: new Container()),
            new Icon(Icons.delete),
          ],
        ),
      ),
      onDismissed: (direction) {
        Intents.removeActivities(Provider.of(context), [activity]);
      },
      child: new Stack(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
                  child: new Icon(
                    tmpType.icon,
                    size: 30.0,
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: new Text(
                        activity.data.containsKey('name') ? activity.data['name'] : '',
                        style: theme.textTheme.subhead,
                      ),
                    ),
                    new Text(
                      activity.data.containsKey('desc') ? activity.data['desc'] : '',
                      style: theme.textTheme.body1,
                    )
                  ],
                )
              ],
            ),
          ),
          new Positioned.fill(
            child: new Container(
              // width: 100.0,
              // height: .0,
              color: tmpType.color,
            ),
          )
        ],
      ),
      // child: new Card(
      //   elevation: 8.0,
      //   color: tmpType.color,
      //   child: new Stack(
      //     children: <Widget>[
      //       // new Row(
      //       //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //       //   children: <Widget>[
      //       //     new Expanded(
      //       //       child: new Container(
      //       //         // width: 100.0,
      //       //         color: tmpType.color,
      //       //       ),
      //       //     ),
      //       //   ],
      //       // ),
      //       new ListTile(
      //         leading: new Icon(tmpType.icon),
      //         isThreeLine: true,
      //         title: new Text(activity.data['name']),
      //         subtitle: new Text(activity.data['desc']),
      //         // trailing: new Icon(Icons.check),
      //         onTap: () {
      //           Intents.setFocused(Provider.of(context), activity: activity);
      //           Intents.editEditing(Provider.of(context), new Activity.from(activity));
      //           Navigator.of(context).pushNamed(Routes.addEditActivity);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

}