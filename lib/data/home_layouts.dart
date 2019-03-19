import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter_calendar/tick.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_card.dart';
import 'package:watoplan/widgets/radio_expansion.dart';

// The key of each HomeLayout must also be its name and in the validKeys
// (the name will be added if it is not already included)
final Map<String, HomeLayout> validLayouts = {
  'list': HomeLayout(
    name: 'list',
    validKeys: ['list', 'schedule'],  // for backward compatability with the database
    defaultOptions: {
      'sorter': 'start',
      'sortRev': false,
    },
  )..withMenuBuilder((HomeLayout self) =>
    (BuildContext context, ExpansionChanged onChanged) {
      final AppState stateVal = Provider.of(context).value;
      final Map<String, dynamic> options = stateVal.homeOptions[self.name];
      final locales = WatoplanLocalizations.of(context);
      final theme = Theme.of(context);
      final sortStr = options != null
        ? options['sortRev']
          ? options['sorter'].split('').reversed.join('').toUpperCase()
          : options['sorter'].toUpperCase()
        : '';

      return RadioExpansion(
        value: self.name,
        groupValue: stateVal.homeLayout,
        onChanged: onChanged,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              locales.layoutList.toUpperCase(),
              style: TextStyle(
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                fontFamily: 'Timeburner',
              )
            ),
            Expanded(child: Container()),
            Text(
              '${locales.by} $sortStr',
              style: TextStyle(
                letterSpacing: 1.4,
                fontFamily: 'Timeburner',
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: locales.validSorts.keys.map(
              (name) => RadioListTile(
                title: Text(
                  locales.validSorts[name](),
                ),
                activeColor: theme.accentColor,
                groupValue: options['sorter'],
                value: name,
                onChanged: (name) {
                  Intents.sortActivities(Provider.of(context), options: options..['sorter'] = name);
                },
              )
            ).toList()
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
            child: OutlineButton(
              padding: const EdgeInsets.all(0.0),
              textColor: options['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).textTheme.subhead.color,
              borderSide: BorderSide(
                color: options['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).hintColor,
              ),
              child: Text(
                options['sortRev'] ? locales.reversed.toUpperCase() : locales.reverse.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Timeburner',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              onPressed: () {
                Intents.sortActivities(Provider.of(context), options: options..['sortRev'] = !options['sortRev']);
              },
            ),
          ),
        ],
      );
    }
  )..withBuilder((HomeLayout self) =>
    (BuildContext context) {
      final AppState stateVal = Provider.of(context).value;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        shrinkWrap: true,
        itemCount: stateVal.filteredActivities.length,
        itemBuilder: (BuildContext context, int i) {
          return ActivityCard(stateVal.filteredActivities[i]);
        },
      );
    }
  ),
  'calendar': HomeLayout(
    name: 'calendar',
    validKeys: [ 'calendar', 'month' ],  // for backward compatability with the database
    defaultOptions: {  },
  )..withMenuBuilder((HomeLayout self) =>
    (BuildContext context, ExpansionChanged onChanged) {
      final AppState stateVal = Provider.of(context).value;
      final Map<String, dynamic> options = stateVal.homeOptions[self.name];
      final locales = WatoplanLocalizations.of(context);
      // debugPrint('${stateVal.homeLayout} + ${self.name}');

      return RadioExpansion(
        value: self.name,
        groupValue: stateVal.homeLayout,
        onChanged: onChanged,
        title: Row(
          children: <Widget>[
            Text(
              locales.layoutCalendar.toUpperCase(),
              style: TextStyle(
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                fontFamily: 'Timeburner',
              )
            ),
          ],
        ),
        trailing: Icon(new IconData(0)),
        children: <Widget>[
          Container(),
        ],
      );
    }
  )..withBuilder((HomeLayout self) =>
    (BuildContext context) {
      final locales = WatoplanLocalizations.of(context);
      final AppState stateVal = Provider.of(context).value;
      final theme = Theme.of(context);

      return ListView(
        children: <Widget>[
          Calendar(
            isExpandable: true,
            showCalendarPickerIcon: false,
            onDateSelected: (DateTime day) {
              Intents.focusOnDay(Provider.of(context), day);
            },
            ticksBuilder: (BuildContext context, DateTime day) {
              return stateVal.activitiesOn(day)
                .map((Activity a) => Tick(
                  color: stateVal.activityTypes.firstWhere((ActivityType t) => t.id == a.typeId).color,
                )).toList();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: stateVal.activitiesOn()
                .map((Activity a) => ActivityCard(a))
                .toList(),
            ),
          ),
        ],
      );
    }
  ),
};

typedef Future ExpansionChanged<T>(T value);
typedef RadioExpansion MenuItemBuilder(BuildContext context, ExpansionChanged onChanged);
typedef Widget LayoutBuilder(BuildContext context);
typedef LayoutBuilder ContextLayoutBuilder(HomeLayout self);
typedef MenuItemBuilder ContextExpansionBuilder(HomeLayout self);

class HomeLayout {

  final String name;
  List<String> validKeys;
  final Map<String, dynamic> defaultOptions;
  MenuItemBuilder menuBuilder;
  LayoutBuilder builder;

  HomeLayout({ this.name, this.validKeys, this.defaultOptions, this.menuBuilder, this.builder }) {
    if (!validKeys.contains(name))
      validKeys.add(name);
  }
  
  HomeLayout copyWith({
    String name,
    List<String> validKeys,
    Map<String, dynamic> defaultOptions,
    MenuItemBuilder menuBuilder,
    LayoutBuilder builder,
  }) => HomeLayout(
    name: name ?? this.name,
    validKeys: validKeys ?? this.validKeys,
    defaultOptions: defaultOptions ?? this.defaultOptions,
    menuBuilder: menuBuilder ?? this.menuBuilder,
    builder: builder ?? this.builder,
  );

  void withMenuBuilder(ContextExpansionBuilder builderWithContext) => menuBuilder = builderWithContext(this);
  void withBuilder(ContextLayoutBuilder builderWithContext) => builder = builderWithContext(this);

}
