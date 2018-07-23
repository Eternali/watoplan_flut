import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/initialization_settings.dart';
import 'package:flutter_local_notifications/platform_specifics/android/initialization_settings_android.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/initialization_settings_ios.dart';
// import 'package:location_picker/location_picker.dart';

FlutterLocalNotificationsPlugin notiPlug = FlutterLocalNotificationsPlugin()
  ..initialize(
    InitializationSettings(
      InitializationSettingsAndroid('app_icon'),
      InitializationSettingsIOS(),
    ),
  );

// LocationPicker.initApiKey('');
