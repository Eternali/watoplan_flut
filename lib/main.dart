import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/screens/HomeScreen.dart';
import 'package:watoplan/screens/AddEditScreen.dart';

void main() {
  return runApp(
    new Watoplan()
  );
}

class Watoplan extends StatelessWidget {

  final List<ActivityType> ACTIVITY_TYPES = [
    new ActivityType(
      name: 'activity',
      icon: Icons.time_to_leave,
      color: new Color(Colors.blueGrey.value),
      params: {
        'name': '',
        'desc': '',
        'location': '',
      }
    ),
    new ActivityType(
      name: 'event',
      icon: Icons.star,
      color: new Color(Colors.deepOrange.value),
      params: {
        'name': '',
        'desc': '',
      }
    ),
    new ActivityType(
      name: 'meeting',
      icon: Icons.people_outline,
      color: new Color(Colors.green.value),
      params: {
        'name': '',
        'desc': '',
        'tags': [],
      }
    ),
    new ActivityType(
      name: 'assessment',
      icon: Icons.note,
      color: new Color(Colors.purple.value),
      params: {
        'name': '',
        'desc': '',
        'tags': [],
      }
    ),
    new ActivityType(
      name: 'project',
      icon: Icons.present_to_all,
      color: new Color(Colors.pink.value),
      params: {
        'name': '',
        'desc': '',
        'tags': [],
      }
    ),
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
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[1],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[2],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[1],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
              }
            ),
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
          Routes.addEditActivity: (context) => new AddEditScreen(),
        }
      ),
    );
  }

}
