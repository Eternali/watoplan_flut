import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/initialization_settings.dart';
import 'package:flutter_local_notifications/platform_specifics/android/initialization_settings_android.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/initialization_settings_ios.dart';
// import 'package:location_picker/location_picker.dart';

FlutterLocalNotificationsPlugin notiPlug = new FlutterLocalNotificationsPlugin()
  ..initialize(
    new InitializationSettings(
      new InitializationSettingsAndroid('app_icon'),
      new InitializationSettingsIOS(),
    ),
  );

// LocationPicker.initApiKey('');
