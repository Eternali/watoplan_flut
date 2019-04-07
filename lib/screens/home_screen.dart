// we're overriding these menus in widgets/popup_menu.dart
import 'package:flutter/material.dart' hide PopupMenuButton, PopupMenuEntry, PopupMenuItem;
import 'package:sam/sam.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/key_strings.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/data/home_layouts.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/data/shared_prefs.dart';
import 'package:watoplan/widgets/popup_menu.dart';

class HomeScreen extends StatefulWidget {

  final String title;
  final List<MenuChoice> overflow = <MenuChoice>[
    MenuChoice(title: 'Settings', icon: Icons.settings, onPressed: (BuildContext context) {
      Navigator.of(context).pushNamed(Routes.settings);
    }),
    MenuChoice(title: 'About', icon: Icons.info, onPressed: (BuildContext context) {
      Navigator.of(context).pushNamed(Routes.about);
    }),
    MenuChoice(title: 'Export', icon: Icons.share, onPressed: (BuildContext context) async {
      if (SharedPrefs().isMobile) {
        await Share.file(
          'Watoplan Database',
          'watoplan.json',
          await Intents.getRawDb(Provider.of(context)),
          'text/json',
        );
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            final locales = WatoplanLocalizations.of(context);
            return AlertDialog(
              title: Text(locales.featureNotSupported),
              content: Text(locales.needsMobile),
              actions: <Widget>[
                new FlatButton(
                  child: Text(locales.close.toUpperCase()),
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      }
    }),
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

  Widget buildDrawerSubtitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Theme.of(context).accentColor
                ),
                margin: const EdgeInsets.symmetric(vertical: 18)
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 18.0,
                  fontFamily: 'Timeburner',
                )
              ),
            ]
          ),
        ],
      ),
    );
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
          PopupMenuButton<MenuChoice>(
            onSelected: (MenuChoice choice) {
              choice.onPressed(context);
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
                  ),
                ],
              ),
            ),
            buildDrawerSubtitle(context, locales.viewAs)
          // gotta love Dart not having any sort of spread operator, forcing the use of ..add and ..addAll all over the place
          ]..addAll(validLayouts.values.map((HomeLayout layout) =>
            layout.menuBuilder(context, (value) {
              return Intents.switchHome(
                Provider.of(context),
                layout: layout.name, options: stateVal.homeOptions[layout.name]
              );
            })
          ))..add(
            buildDrawerSubtitle(context, locales.filterBy),
          )..addAll(
            filterApplicators.values.map((Filter<List> f) => f.build(stateVal.filters[f.name], context))
          )..addAll(validParams.values
            .where((p) => p.filter != null)
            .map((p) => p.filter.build(context))
          )
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
      floatingActionButton: SAM(
        // name: KeyStrings.createFam,
        color: Theme.of(context).accentColor,
        entries: typesToSubFabs(context, stateVal.activityTypes),
        buttonElevation: 0,
      ),
    );
  }
}
