import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/utils/data_utils.dart';



class ActivityCard extends StatefulWidget {

  final Activity activity;
  ActivityCard(this.activity);

  @override
  State<ActivityCard> createState() => new ActivityCardState();

}

class ActivityCardState extends State<ActivityCard> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(duration: new Duration(milliseconds: 800), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation.addListener(() {
      setState(() {  });
    });
    animation.addStatusListener((AnimationStatus status) {  });
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState stateVal = Provider.of(context).value;
    ActivityType tmpType = stateVal.activityTypes.firstWhere((type) => type.id == widget.activity.typeId);

    return new Dismissible(
      key: new Key(widget.activity.id.toString()),
      background: new Container(
        color: Colors.redAccent.withAlpha(200),
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
        Intents.removeActivities(Provider.of(context), [widget.activity]);
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
              right: widget.activity.data.containsKey('progress')
                ? MediaQuery.of(context).size.width
                  - (widget.activity.data['progress'].toDouble() * animation.value * (MediaQuery.of(context).size.width / 100.0))
                : MediaQuery.of(context).size.width * (1 - animation.value),
              top: 0.0,
              bottom: 0.0,
              child: new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(
                    width: 4.0,
                    color: tmpType.color.withAlpha(
                      widget.activity.data.containsKey('priority')
                        ? (widget.activity.data['priority'] * 20) + 55
                        : 55
                    )
                  ),
                  color: tmpType.color.withAlpha(
                    widget.activity.data.containsKey('priority')
                      ? (widget.activity.data['priority'] * 10) + 40
                      : 40,
                  )
                ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              color: tmpType.color.withAlpha(40), // full item will always have this baseline
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
                        widget.activity.data.containsKey('priority')
                          ? (widget.activity.data['priority'] * 15) + 105
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
                            widget.activity.data.containsKey('name') ? widget.activity.data['name'] : '',
                            style: theme.textTheme.subhead.copyWith(fontSize: 18.0),
                          ),
                        ),
                        new Text(
                          widget.activity.data.containsKey('desc') ? widget.activity.data['desc'] : '',
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
                          widget.activity.data.containsKey('start') ? DateTimeUtils.formatEM(widget.activity.data['start']) : '',
                          style: theme.textTheme.body1.copyWith(color: theme.hintColor),
                        ),
                        new Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                          child: new Icon(
                            widget.activity.data.containsKey('notis') && widget.activity.data['notis'].length > 0
                              ? Icons.notifications : IconData(0),
                            size: 12.0,
                          )
                        ),
                        new Text(
                          widget.activity.data.containsKey('end') ? DateTimeUtils.formatEM(widget.activity.data['end']) : '',
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
          Intents.setFocused(Provider.of(context), activity: widget.activity);
          Intents.editEditing(Provider.of(context), new Activity.from(widget.activity));
          Navigator.of(context).pushNamed(Routes.addEditActivity);
        },
      ),
    );
  }

}