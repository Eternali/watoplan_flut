/// This is a calendar widget that displays by month and is draws a lot of elements
/// from the small_calendar plugin found at: https://github.com/ZedTheLed/small_calendar.git
/// 
/// The main differences are that it drops the explicit dynamic updating, instead assuming
/// that all dynamic data will be part of a state management system and will be redrawn automatically.
/// Also, instead of being limited to 3 ticks, this calendar supports a horizontally scrolling list of ticks.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/data/provider.dart';

class CalendarState {

  final DateTime today;
  final DateTime selected;
  final int month;
  final int firstWeekDay;
  final Map<int, String> dayNames;

  CalendarState({
    this.today,
    this.selected,
    this.month,
    this.firstWeekDay,
    this.dayNames,
  });

  CalendarState copyWith({
    DateTime today,
    DateTime selected,
    int month,
    int firstWeekDay,
    Map<int, String> dayNames,
  }) => CalendarState(
    today: today ?? this.today,
    selected: selected ?? this.selected,
    month: month ?? this.month,
    firstWeekDay: firstWeekDay ?? this.firstWeekDay,
    dayNames: dayNames ?? this.dayNames,
  );

  @override
  int get hashCode =>
    today.hashCode +
    selected.hashCode +
    month.hashCode +
    firstWeekDay.hashCode +
    dayNames.hashCode;

}

class CalendarStateObservable extends ValueNotifier {
  CalendarStateObservable(CalendarState value) : super(value);
}

class _CalendarInheritor extends InheritedWidget {

  final CalendarStateObservable state;
  final CalendarState _stateVal;
  final Widget child;

  _CalendarInheritor({ this.state, this.child, })
    : _stateVal = state.value, super(child: child);

  @override
  bool updateShouldNotify(_CalendarInheritor old) {
    return _stateVal != old._stateVal;
  }

}

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

typedef Future<bool> DateHasProperty(DateTime date);
typedef Future<List<T>> GetDateProperties<T>(DateTime date);
typedef FutureOr<void> DateEvent(DateTime date);

class CalendarData extends StatelessWidget {
  
  final int firstWeekDay;
  final Map<int, String> dayNames;
  final GetDateProperties<Tick> genDayTicks;
  final DateHasProperty isToday; // make it easier for mocking
  final DateHasProperty isSelected;
  final VoidCallback onTap;
  Widget child;
  
  CalendarData({
    this.firstWeekDay = DateTime.sunday,
    this.dayNames = const {
      DateTime.sunday: 'Sunday',
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
    },
    this.genDayTicks,
    this.isToday,
    this.isSelected,
    this.onTap,
    @required this.child,
  }) : assert(firstWeekDay != null), assert(dayNames != null) {
    if (!dayNames.containsKey(firstWeekDay)) {
      throw ArgumentError.value(
        firstWeekDay,
        'firstWeekDay',
        '"firstWeekDay" is not a valid weekday. firstWeekDay should be found in the keys of dayNames.',
      );
    }
    if (dayNames.length != 7) {
      throw ArgumentError.value(
        dayNames,
        'dayNames',
        'dayNames should contain a key-pair for every weekday (${dayNames.length} != 7)',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

  }

}

class CalendarStyle extends StatefulWidget {



}

class _CalendarStyleState extends State<CalendarStyle> {

}

class Calendar extends StatefulWidget {

  @override
  State<Calendar> createState() => _CalendarState();

}

class _CalendarState extends State<Calendar> {

  Row _buildDayIndicators() {
    return Row();
  }

  List<Widget> _buildDays(activityTypes, activities) {

  }

  @override
  Widget build(BuildContext context) {
    final stateVal = Provider.of(context);
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        _buildDayIndicators(),
        GridView.count(
          crossAxisCount: 7,
          children: _buildDays(stateVal.activityTypes, stateVal.activities),
        )
      ],
    );
  }

}
