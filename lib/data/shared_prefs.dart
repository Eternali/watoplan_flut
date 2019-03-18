import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SharedPrefs {

  static SharedPrefs _self;
  Database _db;
  StoreRef<String, dynamic> _store;
  SharedPreferences _prefs;

  String path;

  bool get isMobile => Platform.isAndroid && Platform.isIOS;

  factory SharedPrefs([ String loc ]) {
    _self ??= SharedPrefs._init(loc);

    return _self;
  }

  static Future<SharedPrefs> getInstance([ String loc ]) async {
    _self ??= SharedPrefs._init(loc);
    await _self.open();
    return _self;
  }

  SharedPrefs._init([ String loc ]) {
    path = loc ?? '${Directory.current.path}/shared_prefs.db';
  }

  Future open() async {
    if (isMobile) {
      _prefs ??= await SharedPreferences.getInstance();
    } else {
      _db ??= await databaseFactoryIo.openDatabase(path);
      _store ??= StoreRef<String, dynamic>.main();
    }
  }

  Future<String> getString(String key) async {
    if (isMobile) return _prefs.getString(key);
    return (await _store.record(key).get(_db)) as String;
  }

  Future<bool> setString(String key, String value) async {
    if (isMobile) return _prefs.setString(key, value);
    final res = await _store.record(key).put(_db, value);
    return res == value;
  }

  Future<bool> remove(String key) async {
    if (isMobile) return _prefs.remove(key);
    final res = await _store.record(key).delete(_db);
    return res != null;
  }

}