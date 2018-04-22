import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
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
        title: new Text(widget.title ?? WatoplanLocalizations.of(context).appTitle),
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
                    new Padding(padding: new EdgeInsets.symmetric(horizontal: 8.0),),
                    new Text(choice.title)
                  ],
                ),
                )
              ).toList(),
          ),
        ],
      ),
      // body: new ListView(
      //   padding: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),        
      //   children: stateVal.activities.map((activity) => new ActivityCard(activity)).toList(),
      // ),
      body: new ListView.builder(
        padding: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
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
