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
      "activity",
      params: [
        new TypeParam.ext(
          parent: VALID_PARAMS['name'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['desc'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['color'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['location'],
          isOptional: false
        ),
      ]),
    new ActivityType(
      "event",
      params: [
        new TypeParam.ext(
          parent: VALID_PARAMS['name'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['desc'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['color'],
          isOptional: false
        ),
      ]),
    new ActivityType(
      "meeting",
      params: [
        new TypeParam.ext(
          parent: VALID_PARAMS['name'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['desc'],
          isOptional: false
        ),
        new TypeParam.ext(
          parent: VALID_PARAMS['color'],
          isOptional: false
        ),
      ]),
    // new ActivityType("assessment"),
    // new ActivityType("project"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return new Provider(
      state: new AppStateObservable(
        new AppState(
          activities: [
            new Activity(
              type: ACTIVITY_TYPES[1],
              data: {
                'name': 'TEST NAMEsjdkfk',
                'desc': 'TEST DESCRIPTION',
                'color': new Color(0xFFFF9000)
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
