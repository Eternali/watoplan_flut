import 'package:flutter/material.dart';
import 'package:flutter_calendar/date_utils.dart';

import 'package:watoplan/data/provider.dart';
import 'package:watoplan/data/models.dart';

class Tick extends StatelessWidget {

  Color color;

  Tick({ this.color, });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

}

class TickScroller extends StatelessWidget {
    
  final DateTime date;

  TickScroller(this.date);

  // -1 if b is before a, 1 if b is after a, and 0 if they are on the same day
  int getRelation(DateTime a, DateTime b) => DateUtils.isSameDay(a, b)
    ? 0 : b.isAfter(a) ? 1 : b.isBefore(a) ? -1 : null;

  List getTicks({
    List<ActivityType> types,
    List<Activity> activities,
  }) {
    return activities.where(
      (act) => act.data.keys.where(
        (k) => ['start', 'end'].contains(k)
      ).length > 0
    ).where(
      (act) {
        int startIn = act.data.containsKey('start') ? getRelation(act.data['start'], date) : null;
        int endIn = act.data.containsKey('end') ? getRelation(act.data['end'], date) : null;
        return startIn == 0 || endIn == 0 || (startIn == 1 && endIn == -1);
    }).map(
      (act) => [
        act.id,
        act.getType(types).color,
      ]
    ).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;

    return ListView(
      scrollDirection: Axis.horizontal,
      children: getTicks(
        types: stateVal.activityTypes,
        activities: stateVal.activities,
      ).map((idColPair) => Tick(color: idColPair[1])).toList(),
    );
  }

}