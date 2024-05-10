import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class Store {
  static Future<void> saveString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString(
      key,
      value,
    );
  }

  static Future<bool> remove(String key) async {
    final pref = await SharedPreferences.getInstance();

    return pref.remove(
      key,
    );
  }

  static Future<String?> getString(String key) async {
    final pref = await SharedPreferences.getInstance();

    return pref.getString(
      key,
    );
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString(
      key,
      jsonEncode(value),
    );
  }

  static Future<Map<String, dynamic>> getMap(
    String key,
  ) async {
    final map = await getString(
          key,
        ) ??
        {};

    return Future.value(jsonDecode(map.toString()));
  }
}
