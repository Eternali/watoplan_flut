import 'package:date_utils/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:watoplan/init_plugs.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';

class ActivityCard extends StatefulWidget {

  final Activity activity;
  bool enter;
  ActivityCard(this.activity, [ this.enter = true ]);

  @override
  State<ActivityCard> createState() => ActivityCardState();

}

class ActivityCardState extends State<ActivityCard> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  int getIdx(List<Activity> activities) => activities.indexOf(widget.activity);

  @override
  initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 1, curve: Curves.easeOut),
    ));
    animation.addListener(() {
      setState(() {  });
    });
    animation.addStatusListener((AnimationStatus status) {  });
    if (widget.enter) {
      controller.forward();
      widget.enter = false;
    } else {
      controller.value = controller.upperBound;
    }
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locales = WatoplanLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AppStateObservable state = Provider.of(context);
    final ActivityType tmpType = widget.activity.getType(state.value.activityTypes);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.green,
      ),
      child: Dismissible(
        key: Key(widget.activity.id.toString()),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.redAccent.withAlpha(200),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              Expanded(child: Container()),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.redAccent.withAlpha(200),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Container()),
              Icon(Icons.delete),
            ],
          ),
        ),
        onDismissed: (direction) {
          int idx = getIdx(state.value.activities);
          Intents.removeActivities(state, [widget.activity], notiPlug)
            .then((activities) {
                return Scaffold.of(context).showSnackBar(new SnackBar(
                duration: const Duration(seconds: 3),
                content: Text(
                  'Deleted ${tmpType.name} ${activities[0].data.containsKey('name') ? activities[0].data['name'] : ''}',
                ),
                action: SnackBarAction(
                  label: locales.undo.toUpperCase(),
                  onPressed: () {
                    Intents.insertActivity(state, activities[0], idx);
                  },
                ),
              ));
            });
        },
        child: Material(
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    left: 0.0,
                    right: widget.activity.data.containsKey('progress')
                      ? MediaQuery.of(context).size.width
                        - (widget.activity.data['progress'].toDouble() * animation.value * (MediaQuery.of(context).size.width / 100.0))
                      : MediaQuery.of(context).size.width * (1 - animation.value),
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          color: tmpType.color.withAlpha(
                            widget.activity.data.containsKey('priority')
                              ? (widget.activity.data['priority'] * 20) + 55
                              : 55
                          )
                        ),
                        borderRadius: BorderRadius.circular(32),
                        color: tmpType.color.withAlpha(
                          widget.activity.data.containsKey('priority')
                            ? (widget.activity.data['priority'] * 10) + 40
                            : 40,
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: tmpType.color.withAlpha(40), // full item will always have this baseline
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 12, right: 6, top: 8, bottom: 8),
                          child: Icon(
                            tmpType.icon,
                            size: 30.0,
                            color: tmpType.color.withAlpha(
                              widget.activity.data.containsKey('priority')
                                ? (widget.activity.data['priority'] * 15) + 105
                                : 105
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              widget.activity.data.containsKey('name') && widget.activity.data['name'].length > 0
                                ? Padding(
                                  padding: const EdgeInsets.only(bottom: 4, left: 4),
                                  child: Text(
                                    widget.activity.data['name'],
                                    style: theme.textTheme.subhead.copyWith(fontSize: 18.0),
                                  ),
                                ) : null,
                              widget.activity.data.containsKey('desc') && widget.activity.data['desc'].length > 0
                                ? Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    widget.activity.data['desc'],
                                    style: theme.textTheme.body1.copyWith(fontSize: 14.0),
                                  ),
                                ) : null,
                              widget.activity.data.containsKey('long') && widget.activity.data['long'].length > 0
                                ? Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(height: 4.0),
                                      MarkdownBody(
                                        data: widget.activity.data['long'],
                                      ),
                                    ],
                                  ),
                                ) : null,
                              widget.activity.data.containsKey('tags') && widget.activity.data['tags'].length > 0
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Wrap(
                                    children: widget.activity.data['tags'].map<Widget>((tag) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: tag.color, width: 2),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: Text(
                                        tag.name,
                                        style: theme.textTheme.body1.copyWith(fontSize: 12),
                                      ),
                                    )).toList(),
                                  ),
                                ) : null,
                            ].where((it) => it != null).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                widget.activity.data.containsKey('start') ? Utils.formatEM(widget.activity.data['start']) : '',
                                style: theme.textTheme.body1.copyWith(color: theme.hintColor),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                                child: Icon(
                                  widget.activity.data.containsKey('notis') && widget.activity.data['notis'].length > 0
                                    ? Icons.notifications : IconData(0),
                                  size: 12.0,
                                )
                              ),
                              Text(
                                widget.activity.data.containsKey('end') ? Utils.formatEM(widget.activity.data['end']) : '',
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
            ),
            onTap: () {
              Intents.setFocused(state, activity: widget.activity);
              Intents.editEditing(state, Activity.from(widget.activity));
              Navigator.of(context).pushNamed(Routes.addEditActivity);
            },
          ),
        ),
      ),
    );
  }

}