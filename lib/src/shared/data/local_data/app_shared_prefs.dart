import 'dart:convert';
import 'package:flutter_clean_architecture/src/core/routing/route_constants.dart';
import 'package:flutter_clean_architecture/src/core/utils/constants/localdata_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  final SharedPreferences _preferences;

  AppSharedPrefs(this._preferences);

  /// __________ Dark Theme __________ ///
  // get theme
  Future<bool> getIsDarkTheme() async {
    try {
      bool? response = _preferences.getBool(LocalDataConstants.theme);
      return response ?? false;
    } catch (e) {
      return false;
    }
  }

  // set theme mode
  void setDarkTheme(bool isDark) {
    _preferences.setBool(LocalDataConstants.theme, isDark);
  }

  /// __________ Route __________ ///
  // get current route
  Future<String> getCurrentRoute() async {
    try {
      String? response =
          _preferences.getString(LocalDataConstants.currentRoute);
      return response ?? RouteConstants.kHomeScreen.path;
    } catch (e) {
      return RouteConstants.kHomeScreen.path;
    }
  }

  // set current route
  void setCurrentRoute(String currentRoute) {
    _preferences.setString(LocalDataConstants.currentRoute, currentRoute);
  }

  /// __________ Token Handling __________ ///
  // set access token
  void setAccessToken(Map<String, dynamic> data) {
    String jsonData = jsonEncode(data);
    _preferences.setString(LocalDataConstants.accessToken, jsonData);
  }

  // set refresh token
  void setRefreshToken(Map<String, dynamic> data) {
    String jsonData = jsonEncode(data);
    _preferences.setString(LocalDataConstants.refreshToken, jsonData);
  }

  // get access token
  Future<Map<String, dynamic>> getAccessToken() async {
    try {
      String? jsonString =
          _preferences.getString(LocalDataConstants.accessToken);
      if (jsonString != null) {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      }
      return <String, dynamic>{};
    } catch (e) {
      return <String, dynamic>{};
    }
  }

  // get refresh token
  Future<Map<String, dynamic>> getRefreshToken() async {
    try {
      String? jsonString =
          _preferences.getString(LocalDataConstants.refreshToken);
      if (jsonString != null) {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      }
      return <String, dynamic>{};
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}
