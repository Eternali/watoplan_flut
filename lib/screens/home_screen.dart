import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/key_strings.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/data/home_layouts.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/fam.dart';

class HomeScreen extends StatefulWidget {

  final String title;
  List<MenuChoice> overflow = const <MenuChoice>[
    const MenuChoice(title: 'Settings', icon: Icons.settings, route: Routes.settings),
    const MenuChoice(title: 'About', icon: Icons.info, route: Routes.about)
  ];

  HomeScreen({ Key key, this.title }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  List<SubFAB> typesToSubFabs(BuildContext context, List<ActivityType> types) {
    return types
      .map((it) =>
        SubFAB(
          icon: it.icon,
          label: it.name,
          color: it.color,
          onPressed: () {
            Intents.setFocused(Provider.of(context), index: -(types.indexOf(it) + 1));
            Intents.editEditing(
              Provider.of(context),
              it.createActivity()
            );
            Navigator.of(context).pushNamed(Routes.addEditActivity);
          },
        )
      ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    final locales = WatoplanLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title ?? locales.appTitle),
        actions: <Widget>[
          PopupMenuButton<ActivityType>(
            icon: Icon(Icons.add),
            onSelected: (ActivityType type) {
              Intents.setFocused(Provider.of(context), index: -(stateVal.activityTypes.indexOf(type) + 1));
              Intents.editEditing(
                Provider.of(context),
                Activity(
                  type: type,
                  data: type.params
                    .map((key, value) => MapEntry(key, value is DateTime
                      ? Utils.copyWith(DateTime.now(), second: 0, millisecond: 0)
                      : value
                    )),
                )
              );
              Navigator.of(context).pushNamed(Routes.addEditActivity);
            },
            itemBuilder: (BuildContext context) =>
              stateVal.activityTypes.map((type) =>
                PopupMenuItem<ActivityType>(
                  value: type,
                  child: ListTileTheme(
                    iconColor: type.color,
                    textColor: type.color,
                    child: ListTile(
                      leading: Icon(type.icon),
                      title: Text(type.name),
                    ),
                  ),
                )
              ).toList(),
          ),
          PopupMenuButton<MenuChoice>(
            onSelected: (MenuChoice choice) {
              Navigator.of(context).pushNamed(choice.route);
            },
            itemBuilder: (BuildContext context) =>
              widget.overflow.map((MenuChoice choice) =>
                PopupMenuItem<MenuChoice>(
                value: choice,
                child: Row(
                  children: <Widget>[
                    Icon(choice.icon),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                    Text(choice.title)
                  ],
                ),
                )
              ).toList(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 18.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/icons/logo.png', width: 36.0, height: 36.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      locales.appTitle,
                      style: TextStyle(
                        letterSpacing: 2.6,
                        fontSize: 24.0,
                        fontFamily: 'Timeburner',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
          ]..addAll(validLayouts.values.map((HomeLayout layout) =>
            layout.menuBuilder(context, (value) {
              return Intents.switchHome(
                Provider.of(context),
                layout: layout.name, options: stateVal.homeOptions[layout.name]
              );
            })
          )),
        ),
      ),
      body: SafeArea(
        child: validLayouts[stateVal.homeLayout]?.builder(context) ?? Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${locales.layoutUndefined} ${locales.updateError}',
              textAlign: TextAlign.center,
              style: theme.textTheme.body2.copyWith(fontSize: 18.0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionMenu(
        key: const Key('create-fam'),
        name: KeyStrings.createFam,
        color: Theme.of(context).accentColor,
        entries: typesToSubFabs(context, stateVal.activityTypes),
        expanded: true,
        // expansionDirection: Axis.horizontal,
      ),
    );
  }
}
