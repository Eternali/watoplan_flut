import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/home_layouts.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/utils/data_utils.dart';
import 'package:watoplan/widgets/fam.dart';
import 'package:watoplan/widgets/expansion_radio_group.dart';

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

  // Generate a list of 4 FABs to display the most used activityTypes for easy access
  List<SubFAB> typesToSubFabs(BuildContext context, List<ActivityType> types, List<Activity> activities) {
    List toShow = types
      .map((it) =>
        [it, activities.where((act) => act.typeId == it.id).length]
      ).toList()
      ..sort((a, b) => (b[1] as int).compareTo(a[1] as int));

    return toShow
      .sublist(0, toShow.length >= 4 ? 4 : toShow.length)
      .reversed.toList()
      .map((it) => it[0] as ActivityType).toList()
      .map((it) =>
        new SubFAB(
          icon: it.icon,
          label: it.name,
          color: it.color,
          onPressed: () {
            Intents.setFocused(Provider.of(context), indice: -(types.indexOf(it) + 1));
            Intents.editEditing(
              Provider.of(context),
              new Activity(
                type: it,
                data: it.params
                  .map((key, value) => new MapEntry(key, value is DateTime
                    ? DateTimeUtils.copyWith(DateTime.now(), second: 0, millisecond: 0)
                    : value
                  )),
              )
            );
            Navigator.of(context).pushNamed(Routes.addEditActivity);
          },
        )
      ).toList();
  }

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;
    final locales = WatoplanLocalizations.of(context);

    widget.subFabs.value = typesToSubFabs(context, stateVal.activityTypes, stateVal.activities);

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title ?? locales.appTitle),
        actions: <Widget>[
          new PopupMenuButton<ActivityType>(
            icon: new Icon(Icons.add),
            onSelected: (ActivityType type) {
              Intents.setFocused(Provider.of(context), indice: -(stateVal.activityTypes.indexOf(type) + 1));
              Intents.editEditing(
                Provider.of(context),
                new Activity(
                  type: type,
                  data: type.params
                    .map((key, value) => new MapEntry(key, value is DateTime
                      ? DateTimeUtils.copyWith(DateTime.now(), second: 0, millisecond: 0)
                      : value
                    )),
                )
              );
              Navigator.of(context).pushNamed(Routes.addEditActivity);
            },
            itemBuilder: (BuildContext context) =>
              stateVal.activityTypes.map((type) =>
                new PopupMenuItem<ActivityType>(
                  value: type,
                  child: new ListTileTheme(
                    iconColor: type.color,
                    textColor: type.color,
                    child: new ListTile(
                      leading: new Icon(type.icon),
                      title: new Text(type.name),
                    ),
                  ),
                )
              ).toList(),
          ),
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
                    new Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
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
          ]..add(
            new ExpansionRadioGroup(
              name: 'layoutMenu',
              members: validLayouts.values.map((HomeLayout layout) => layout.menuBuilder(context)).toList(),
            )
          ),
        ),
      ),
      body: new SafeArea(
        child: validLayouts[stateVal.homeLayout].builder(context)
      ),
      floatingActionButton: new FloatingActionMenu(
        color: Theme.of(context).accentColor,
        entries: widget.subFabs,
        expanded: true,
      ),
    );
  }
}
