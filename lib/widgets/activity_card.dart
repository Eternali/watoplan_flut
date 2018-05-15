import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/utils/data_utils.dart';

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
      child: new InkWell(
        child: new Stack(
          children: <Widget>[
            // new LayoutBuilder(
            //   builder: (BuildContext context, BoxConstraints constraints) =>
            //     new Container(
            //       width: constraints.maxWidth,
            //       height: constraints.maxWidth,
            //       color: tmpType.color,
            //     )
            // ),
              new Positioned.fill(
              left: 0.0,
              right: activity.data.containsKey('progress')
                ? MediaQuery.of(context).size.width
                  - (activity.data['progress'].toDouble() * (MediaQuery.of(context).size.width / 100.0))
                : 0.0,
              top: 0.0,
              bottom: 0.0,
              child: new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(
                    width: 4.0,
                    color: tmpType.color.withAlpha(
                      activity.data.containsKey('priority')
                        ? (activity.data['priority'] * 20) + 55
                        : 55
                    )
                  ),
                ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              color: tmpType.color.withAlpha(
                activity.data.containsKey('priority')
                  ? (activity.data['priority'] * 7) + 30
                  : 30
              ),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: new Icon(
                      tmpType.icon,
                      size: 30.0,
                      color: tmpType.color.withAlpha(
                        activity.data.containsKey('priority')
                          ? (activity.data['priority'] * 15) + 105
                          : 105
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: new Text(
                            activity.data.containsKey('name') ? activity.data['name'] : '',
                            style: theme.textTheme.subhead.copyWith(fontSize: 18.0),
                          ),
                        ),
                        new Text(
                          activity.data.containsKey('desc') ? activity.data['desc'] : '',
                          style: theme.textTheme.body1.copyWith(fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          activity.data.containsKey('start') ? DateTimeUtils.formatEM(activity.data['start']) : '',
                          style: theme.textTheme.body1.copyWith(color: theme.hintColor),
                        ),
                        new Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                          child: new Icon(
                            activity.data.containsKey('notis') && activity.data['notis'].length > 0
                              ? Icons.notifications : IconData(0),
                            size: 12.0,
                          )
                        ),
                        new Text(
                          activity.data.containsKey('end') ? DateTimeUtils.formatEM(activity.data['end']) : '',
                          style: theme.textTheme.body1.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Intents.setFocused(Provider.of(context), activity: activity);
          Intents.editEditing(Provider.of(context), new Activity.from(activity));
          Navigator.of(context).pushNamed(Routes.addEditActivity);
        },
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