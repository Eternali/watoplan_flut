import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:location_picker/location_picker.dart';

FlutterLocalNotificationsPlugin notiPlug = (Platform.isAndroid || Platform.isIOS) ? (FlutterLocalNotificationsPlugin()
  ..initialize(
    InitializationSettings(
      AndroidInitializationSettings('app_icon'),
      IOSInitializationSettings(),
    ),
  )) : null;

// LocationPicker.initApiKey('');
