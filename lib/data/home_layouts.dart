import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter_calendar/calendar_tile.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_card.dart';
import 'package:watoplan/widgets/radio_expansion.dart';


final Map<String, HomeLayout> validLayouts = {
  'schedule': new HomeLayout(
    name: 'schedule',
    defaultOptions: {
      'sorter': 'start',
      'sortRev': false,
    },
    onChange: (AppStateObservable appState, Map<String, dynamic> options) async {
      // if the preferences schema changes this could error out because an installed app
      // could already have the field populated with an invalid value.
      try {
        await Intents.sortActivities(appState, sorterName: options['sorter'], reversed: options['sortRev']);
        return true;
      } on Error {
        return false;
      }
    }
  )..withMenuBuilder((HomeLayout self) =>
    (BuildContext context) {
      final AppState stateVal = Provider.of(context).value;
      final Map<String, dynamic> options = stateVal.homeOptions[self.name];
      final locales = WatoplanLocalizations.of(context);

      return new RadioExpansion(
        value: self.name,
        groupValue: stateVal.homeLayout,
        onChanged: (value) {
          Intents.switchHome(Provider.of(context), layout: value, options: options);
        },
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              locales.layoutList.toUpperCase(),
              style: new TextStyle(
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                fontFamily: 'Timeburner',
              )
            ),
            new Expanded(child: new Container()),
            new Text(
              '${locales.by} '
              '${options['sortRev'] ? options['sorter'].split('').reversed.join('').toUpperCase() : options['sorter'].toUpperCase()}',
              style: new TextStyle(
                letterSpacing: 1.4,
                fontFamily: 'Timeburner',
              ),
            )
          ],
        ),
        children: <Widget>[
          new Column(
            children: locales.validSorts.keys.map(
              (name) => new RadioListTile(
                title: new Text(
                  locales.validSorts[name](),
                ),
                groupValue: options['sorter'],
                value: name,
                onChanged: (name) {
                  Intents.sortActivities(Provider.of(context), sorterName: name);
                },
              )
            ).toList()
          ),
          new Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
            child: new OutlineButton(
              padding: const EdgeInsets.all(0.0),
              textColor: options['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).textTheme.subhead.color,
              borderSide: new BorderSide(
                color: options['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).hintColor,
              ),
              child: new Text(
                options['sortRev'] ? locales.reversed.toUpperCase() : locales.reverse.toUpperCase(),
                style: new TextStyle(
                  fontFamily: 'Timeburner',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              onPressed: () {
                Intents.sortActivities(Provider.of(context), sorterName: options['sortRev'], reversed: !options['sortRev']);
              },
            ),
          ),
        ],
      );
    }
  )..withBuilder((HomeLayout self) =>
    (BuildContext context) {
      final AppState stateVal = Provider.of(context).value;

      return new ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        shrinkWrap: true,
        itemCount: stateVal.activities.length,
        itemBuilder: (BuildContext context, int indice) {
          return new ActivityCard(stateVal.activities[indice]);
        },
      );
    }
  ),
  'month': new HomeLayout(
    name: 'month',
    defaultOptions: {  },
    onChange: (AppStateObservable appState, Map<String, dynamic> options) async {

    }
  )..withMenuBuilder((HomeLayout self) =>
    (BuildContext context) {
      final AppState stateVal = Provider.of(context).value;
      final Map<String, dynamic> options = stateVal.homeOptions[self.name];
      final locales = WatoplanLocalizations.of(context);

      return new RadioExpansion(
        value: self.name,
        groupValue: stateVal.homeLayout,
        onChanged: (value) {
          Intents.switchHome(Provider.of(context), layout: value, options: options);
        },
        title: new Row(
          children: <Widget>[
            new Text(
              locales.layoutMonth.toUpperCase(),
              style: new TextStyle(
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                fontFamily: 'Timeburner',
              )
            ),
          ],
        ),
        trailing: new Icon(new IconData(0)),
        children: <Widget>[
          new Container()
        ],
      );
    }
  )..withBuilder((HomeLayout self) =>
    (BuildContext context) {
      final AppState stateVal = Provider.of(context).value;
      final locales = WatoplanLocalizations.of(context);
      
      return new Calendar(
        dayBuilder: (BuildContext context, DateTime day) => new Container(
          child: new Text('test'),
        ),
      );
    }
  ),
};

typedef RadioExpansion MenuItemBuilder(BuildContext context);
typedef Widget LayoutBuilder(BuildContext context);
typedef LayoutBuilder ContextLayoutBuilder(HomeLayout self);
typedef MenuItemBuilder ContextExpansionBuilder(HomeLayout self);
typedef Future LayoutDepsChange(AppStateObservable appState, Map<String, dynamic> options);

class HomeLayout {

  final String name;
  final Map<String, dynamic> defaultOptions;
  MenuItemBuilder menuBuilder;
  LayoutBuilder builder;
  final LayoutDepsChange onChange;

  HomeLayout({ this.name, this.defaultOptions, this.menuBuilder, this.builder, this.onChange });
  
  HomeLayout copyWith({
    String name,
    Map<String, dynamic> defaultOptions,
    MenuItemBuilder menuBuilder,
    LayoutBuilder builder,
    LayoutDepsChange onChange,
  }) => new HomeLayout(
    name: name ?? this.name,
    defaultOptions: defaultOptions ?? this.defaultOptions,
    menuBuilder: menuBuilder ?? this.menuBuilder,
    builder: builder ?? this.builder,
    onChange: onChange ?? this.onChange,
  );

  void withMenuBuilder(ContextExpansionBuilder builderWithContext) => menuBuilder = builderWithContext(this);
  void withBuilder(ContextLayoutBuilder builderWithContext) => builder = builderWithContext(this);

}
