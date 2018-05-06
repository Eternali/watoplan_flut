import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/activity_card.dart';
import 'package:watoplan/widgets/fam.dart';

class HomeScreen extends StatefulWidget {

  final String title;
  List<MenuChoice> overflow = const <MenuChoice>[
    const MenuChoice(title: 'Settings', icon: Icons.settings, route: Routes.settings),
    const MenuChoice(title: 'About', icon: Icons.info, route: Routes.about)
  ];
  ValueNotifier<List<SubFAB>> subFabs = ValueNotifier([]);

  HomeScreen({ Key key, this.title }) : super(key: key);

  @override
  State<HomeScreen> createState() => new HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;
    WatoplanLocalizations locales = WatoplanLocalizations.of(context);

    List<SubFAB> typesToSubFabs(List<ActivityType> types) {
      return types.map(
        (it) => new SubFAB(
          icon: it.icon,
          color: it.color,
          onPressed: () {
            Intents.setFocused(Provider.of(context), indice: -(types.indexOf(it) + 1));
            Navigator.of(context).pushNamed(Routes.addEditActivity);
          },
        )
      ).toList();
    }

    widget.subFabs.value = typesToSubFabs(stateVal.activityTypes);

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title ?? locales.appTitle),
        actions: <Widget>[
          new PopupMenuButton<MenuChoice>(
            onSelected: (MenuChoice choice) {
              Navigator.of(context).pushNamed(choice.route);
            },
            itemBuilder: (BuildContext context) =>
              widget.overflow.map((MenuChoice choice) =>
                new PopupMenuItem<MenuChoice>(
                value: choice,
                child: new Row(
                  children: <Widget>[
                    new Icon(choice.icon),
                    new Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),),
                    new Text(choice.title)
                  ],
                ),
                )
              ).toList(),
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 18.0, bottom: 8.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Image.asset('assets/icons/logo.png', width: 36.0, height: 36.0,),
                  new Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: new Text(
                      locales.appTitle,
                      style: new TextStyle(
                        letterSpacing: 2.6,
                        fontSize: 24.0,
                        fontFamily: 'Timeburner',
                      ),
                    ),
                  )
                ],
              ),
            ),
            new Divider(),
            new Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 8.0, bottom: 14.0),
              child: new ExpansionTile(
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(
                      locales.schedule.toUpperCase(),
                      style: new TextStyle(
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Timeburner',
                      )
                    ),
                    new Expanded(child: new Container()),
                    new Text(
                      stateVal.sortRev ? stateVal.sorter.split('').reversed.join('').toUpperCase() : stateVal.sorter.toUpperCase(),
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
                          setState(() { Intents.sortActivities(Provider.of(context), name); });
                        },
                      )
                    ).toList(),
                  ),
                  new Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
                    child: new OutlineButton(
                      padding: const EdgeInsets.all(0.0),
                      textColor: stateVal.sortRev ? Theme.of(context).accentColor : Theme.of(context).primaryTextTheme.button.color,
                      child: new Text(
                        stateVal.sortRev ? locales.reversed.toUpperCase() : locales.reverse.toUpperCase(),
                        style: new TextStyle(
                          fontFamily: 'Timeburner',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      onPressed: () { Intents.sortActivities(Provider.of(context), stateVal.sorter, !stateVal.sortRev); },
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
      // body: new AnimatedList(
      //   padding: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),        
      //   children: stateVal.activities.map((activity) => new ActivityCard(activity)).toList(),
      // ),
      body: new ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        shrinkWrap: true,
        itemCount: stateVal.activities.length,
        itemBuilder: (BuildContext context, int indice) {
          return new ActivityCard(stateVal.activities[indice]);
        },
      ),
      floatingActionButton: new FloatingActionMenu(
        color: Theme.of(context).accentColor,
        width: 56.0,
        height: 70.0,
        entries: widget.subFabs,  // (() { widget.subFabs.value = typesToSubFABS(stateVal.activityTypes); return widget.subFabs; })(),
      ),
    );
  }
}
