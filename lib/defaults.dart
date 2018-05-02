import 'package:flutter/material.dart';

import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/models.dart';

const PreloadedIcons = <IconData>[
  Icons.album,
  Icons.time_to_leave,
  Icons.settings_ethernet,
  Icons.settings,
  Icons.people_outline,
  Icons.note,
  Icons.present_to_all,
];

final List<ActivityType> defaultActivityTypes = [
  new ActivityType(
    name: 'activity',
    icon: Icons.time_to_leave,
    color: new Color(Colors.blueGrey.value),
    params: {
      'name': '',
      'desc': '',
      'progress': 0,
      'priority': 0,
      'start': new DateTime.now(),
      'end': new DateTime.now(),
      'notis': <Noti>[],
    }
  ),
  new ActivityType(
    name: 'event',
    icon: Icons.settings,
    color: new Color(Colors.deepOrange.value),
    params: {
      'name': '',
      'desc': '',
      'priority': 0,
      'start': new DateTime.now(),
      'end': new DateTime.now(),
      'notis': <Noti>[],
    }
  ),
  new ActivityType(
    name: 'meeting',
    icon: Icons.people_outline,
    color: new Color(Colors.green.value),
    params: {
      'name': '',
      'desc': '',
      'priority': 0,
      'start': new DateTime.now(),
      'end': new DateTime.now(),
      'notis': <Noti>[],
    }
  ),
  new ActivityType(
    name: 'assessment',
    icon: Icons.note,
    color: new Color(Colors.purple.value),
    params: {
      'name': '',
      'desc': '',
      'progress': 0,
      'priority': 0,
      'start': new DateTime.now(),
      'notis': <Noti>[],
    }
  ),
  new ActivityType(
    name: 'project',
    icon: Icons.present_to_all,
    color: new Color(Colors.pink.value),
    params: {
      'name': '',
      'desc': '',
      'progress': 0,
      'priority': 0,
      'start': new DateTime.now(),
    }
  ),
];

final List<Activity> defaultActivities = [
  new Activity(
    type: defaultActivityTypes[4],
    data: {
      'name': 'new name',
      'desc': 'new description more',
    }
  ),
  new Activity(
    type: defaultActivityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
      'notis': <Noti>[new Noti(title: '', msg: '', when: new DateTime(2018), type: NotiTypes['EMAIL'])],
    }
  ),
  new Activity(
    type: defaultActivityTypes[1],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: defaultActivityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: defaultActivityTypes[2],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: defaultActivityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: defaultActivityTypes[1],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
  new Activity(
    type: defaultActivityTypes[0],
    data: {
      'name': 'TEST NAME',
      'desc': 'TEST DESCRIPTION',
    }
  ),
];
