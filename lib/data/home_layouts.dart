import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_card.dart';


final Map<String, HomeLayout> validLayouts = {
  'schedule': new HomeLayout(
    name: 'schedule',
    menuBuilder: (BuildContext context) {
      AppState stateVal = Provider.of(context).value;
      WatoplanLocalizations locales = WatoplanLocalizations.of(context);
      return new ExpansionTile(
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
              '${ stateVal.layoutOptions['sortRev'] ? stateVal.layoutOptions['sorter'].split('').reversed.join('').toUpperCase() : stateVal.sorter.toUpperCase()}',
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
                groupValue: stateVal.sorter,
                value: name,
                onChanged: (name) {
                  Intents.sortActivities(Provider.of(context), sorterName: name);
                },
              )
            ).toList(),
          ),
          new Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
            child: new OutlineButton(
              padding: const EdgeInsets.all(0.0),
              textColor: stateVal.sortRev ? Theme.of(context).accentColor : Theme.of(context).textTheme.subhead.color,
              borderSide: new BorderSide(
                color: stateVal.sortRev ? Theme.of(context).accentColor : Theme.of(context).hintColor,
              ),
              child: new Text(
                stateVal.sortRev ? locales.reversed.toUpperCase() : locales.reverse.toUpperCase(),
                style: new TextStyle(
                  fontFamily: 'Timeburner',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              onPressed: () {
                Intents.sortActivities(Provider.of(context), sorterName: stateVal.sorter, reversed: !stateVal.sortRev);
              },
            ),
          )
        ],
      );
    },
    builder: (BuildContext context) {
      AppState stateVal = Provider.of(context).value;
      return new ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        shrinkWrap: true,
        itemCount: stateVal.activities.length,
        itemBuilder: (BuildContext context, int indice) {
          return new ActivityCard(stateVal.activities[indice]);
        },
      );
    },
  ),
  'month': new HomeLayout(
    name: 'month',
    menuBuilder: (BuildContext context) {},
    builder: (BuildContext context) {},
  ),
};


typedef Widget LayoutBuilder(BuildContext context);

class HomeLayout {

  final String name;
  final LayoutBuilder menuBuilder;
  final LayoutBuilder builder;

  HomeLayout({ this.name, this.menuBuilder, this.builder });
  
  HomeLayout copyWith({
    String name,
    LayoutBuilder menuBuilder,
    LayoutBuilder builder,
  }) => new HomeLayout(
    name: name ?? this.name,
    menuBuilder: menuBuilder ?? this.menuBuilder,
    builder: builder ?? this.builder,
  );

}
