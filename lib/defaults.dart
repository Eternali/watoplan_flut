import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

final List<ActivityType> activityTypes = [
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
    type: activityTypes[4],
    data: {
      'name': 'new name',
      'desc': 'new description more',
      'tags': ['important', 'new', 'yay'],
    }
  ),
  new Activity(
    type: activityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[1],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[2],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[1],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: activityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
];
