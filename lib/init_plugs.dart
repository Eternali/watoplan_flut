import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:location_picker/location_picker.dart';

FlutterLocalNotificationsPlugin notiPlug = FlutterLocalNotificationsPlugin()
  ..initialize(
    InitializationSettings(
      AndroidInitializationSettings('app_icon'),
      IOSInitializationSettings(),
    ),
  );

// LocationPicker.initApiKey('');
