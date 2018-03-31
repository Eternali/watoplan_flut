import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/screens/HomeScreen.dart';

void main() {
  return runApp(
    new Watoplan()
  );
}

class Watoplan extends StatelessWidget {

  final List<ActivityType> ACTIVITY_TYPES = [
    new ActivityType(
      'activity',
      params: {
        'name': '',
        'desc': '',
        'color': new Color(0xFFFF9000),
        'icon': Icons.person_outline,
        'location': '',
      }
    ),
    new ActivityType(
      'event',
      params: {
        'name': '',
        'desc': '',
        'color': new Color(0xFFFFFFFF),
        'icon': Icons.star,
      }
    ),
    // new ActivityType(
    //   'meeting',
    //   params: {

    //   }
    // ),
    // new ActivityType('assessment'),
    // new ActivityType('project'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return new Provider(
      state: new AppStateObservable(
        new AppState(
          activities: [
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAMEsjdkfk',
                'desc': 'TEST DESCRIPTION',
                'color': new Color(Colors.amberAccent.value)
              }
            )
          ],
          activityTypes: ACTIVITY_TYPES,
          focused: 0
        )
      ),
      child: new MaterialApp(
        title: 'watoplan',
        theme: new ThemeData.dark(),
        localizationsDelegates: [
          new WatoplanLocalizationsDelegate()
        ],
        routes: {
          Routes.home: (context) => new HomeScreen(title: 'WAToPlan'),
        }
      ),
    );
  }

}
