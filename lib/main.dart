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
      'activity',
      params: {
        'name': '',
        'desc': '',
        'color': new Color(Colors.blueGrey.value),
        'icon': Icons.time_to_leave,
        'location': '',
      }
    ),
    new ActivityType(
      'event',
      params: {
        'name': '',
        'desc': '',
        'color': new Color(Colors.deepOrange.value),
        'icon': Icons.star,
      }
    ),
    new ActivityType(
      'meeting',
      params: {
        'name': '',
        'desc': '',
        'tags': new List(),
        'color': new Color(Colors.green.value),
        'icon': Icons.people_outline
      }
    ),
    new ActivityType(
      'assessment',
      params: {
        'name': '',
        'desc': '',
        'tags': new List(),
        'color': new Color(Colors.purple.value),
        'icon': Icons.note
      }
    ),
    new ActivityType(
      'project',
      params: {
        'name': '',
        'desc': '',
        'tags': new List(),
        'color': new Color(Colors.pink.value),
        'icon': Icons.present_to_all
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
                'icon': Icons.star_border
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[1],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.star_border
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.star_border
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[2],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.star_border
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.star_border
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[1],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.backup
              }
            ),
            new Activity(
              type: ACTIVITY_TYPES[0],
              data: {
                'name': 'TEST NAME',
                'desc': 'TEST DESCRIPTION',
                'icon': Icons.local_cafe
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
