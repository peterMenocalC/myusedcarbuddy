import 'dart:collection';
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

class SharedPreferencesHelper {
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String USERID = "userid";
  static const String NAME = "name";
  static String userId;
  static String name;

  static Future<bool> getSubCategoryIdStatusCompleted(
      String orderId, String subCategoryId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var mapStr = prefs.getString(orderId) ?? "";
    if (mapStr.isEmptyOrNull) {
      return Future.value(false);
    } else {
      LinkedHashMap<String, dynamic> map = json.decode(mapStr);
      var isCompleted = map[subCategoryId] ?? false;
      return Future.value(isCompleted);
    }
  }

  static Future<bool> setSubCategoryIdStatusCompleted(
      String orderId, String subCategoryId, bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var mapStr = prefs.getString(orderId) ?? "";
    if (mapStr.isEmptyOrNull) {
      Map<String, bool> map = Map();
      map[subCategoryId] = completed;
      return prefs.setString(orderId, json.encode(map));
    } else {
      LinkedHashMap<String, dynamic> map = json.decode(mapStr);
      map[subCategoryId] = completed;
      return prefs.setString(orderId, json.encode(map));
    }
  }

  static Future<bool> isAllDataFilled(String orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var mapStr = prefs.getString(orderId) ?? "";
    if (mapStr.isEmptyOrNull) {
      return Future.value(false);
    } else {
      LinkedHashMap<String, dynamic> map = json.decode(mapStr);
      bool isDataFilled = false;
      for (int i = 0; i < map.length; i++) {
        bool isCompleted = map.values.elementAt(i);
        if (!isCompleted) {
          return Future.value(false);
        } else {
          isDataFilled = true;
        }
      }
      return Future.value(isDataFilled);
    }
  }

  static setEmailPassword(String email, String password, String userId, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EMAIL, email);
    prefs.setString(PASSWORD, password);
    prefs.setString(USERID, userId);
    prefs.setString(NAME, name);
  }

  static clearPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = null;
    name = null;
    prefs.clear();
  }
}
