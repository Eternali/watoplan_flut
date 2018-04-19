import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/routes.dart';
import 'package:watoplan/themes.dart';
import 'package:watoplan/screens/home_screen.dart';
import 'package:watoplan/screens/add_edit_screen.dart';
import 'package:watoplan/screens/add_edit_type_screen.dart';
import 'package:watoplan/screens/settings_screen.dart';
import 'package:watoplan/screens/about_screen.dart';

void main() {
  return runApp(
    new Watoplan()
  );
}

final List<ActivityType> ACTIVITY_TYPES = [
  new ActivityType(
    name: 'activity',
    icon: Icons.time_to_leave,
    color: new Color(Colors.blueGrey.value),
    params: {
      'name': '',
      'desc': '',
      'datetime': new DateTime.now(),
    }
  ),
  new ActivityType(
    name: 'event',
    icon: Icons.settings,
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
      'tags': <String>[],
    }
  ),
  new ActivityType(
    name: 'assessment',
    icon: Icons.note,
    color: new Color(Colors.purple.value),
    params: {
      'name': '',
      'desc': '',
      'tags': <String>[],
    }
  ),
  new ActivityType(
    name: 'project',
    icon: Icons.present_to_all,
    color: new Color(Colors.pink.value),
    params: {
      'name': '',
      'desc': '',
      'tags': <String>[],
    }
  ),
];

final List<Activity> activities = [
  new Activity(
    type: ACTIVITY_TYPES[4],
    data: {
      'name': 'new name',
      'desc': 'new description more',
      'tags': ['important', 'new', 'yay'],
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
];

class Watoplan extends StatefulWidget {

  getApplicationDocumentsDirectory()
    .then((dir) => new LocalDb('$dir/watoplan.json');

  final watoplanState = new AppStateObservable(
    new AppState(
      activities: activities,
      activityTypes: ACTIVITY_TYPES,
      focused: 0,
      theme: DarkTheme,
    )
  );
  
  @override
  State<Watoplan> createState() => new WatoplanState();

}

class WatoplanState extends State<Watoplan> {

  @override
  Widget build(BuildContext context) {
    // getApplicationDocumentsDirectory()
    //   .then((dir) => LevelDB.openUtf8('${dir.path}/testdb'))
    //   .then((db) {
    //     db.put('testkey', 'testval');
    //     print('testing: testkey = ${db.get('testkey')}');
    //   });
    // final db = new WatoplanDb('mongodb://127.0.0.1/watoplan');
    // db.load(activityTypes, activities);
    return new Provider(
      state: widget.watoplanState,
      child: new MaterialApp(
        title: 'watoplan',
        theme: widget.watoplanState.value.theme,
        localizationsDelegates: [
          new WatoplanLocalizationsDelegate()
        ],
        routes: {
          Routes.home: (context) => new HomeScreen(title: 'WAToPlan'),
          Routes.addEditActivity: (context) => new AddEditScreen(),
          Routes.addEditActivityType: (context) => new AddEditTypeScreen(),
          Routes.settings: (context) => new SettingsScreen(),
          Routes.about: (context) => new AboutScreen(),
        }
      ),
    );
  }

}
