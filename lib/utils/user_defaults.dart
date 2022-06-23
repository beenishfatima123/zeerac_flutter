import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class UserDefaults {
  static SharedPreferences? sharedPreferences;

  setBoolValue(String key, bool value) async {
    final SharedPreferences sharedPreferences = await getPref();
    sharedPreferences.setBool(key, value);
  }

  setString(String key, String value) async {
    final SharedPreferences sharedPreferences = await getPref();
    sharedPreferences.setString(key, value);
  }

  static clearAll() {
    if (sharedPreferences != null) {
      sharedPreferences!.clear();
    }
  }

  static Future<SharedPreferences> getPref() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences!;
  }

  bool getBoolValue(String key, bool defaultValue) {
    if (sharedPreferences != null) {
      return sharedPreferences!.containsKey(key)
          ? sharedPreferences!.getBool(key)!
          : defaultValue;
    }
    return defaultValue;
  }

  String getStringValue(String key, String defaultValue) {
    if (sharedPreferences != null) {
      return sharedPreferences!.containsKey(key)
          ? sharedPreferences!.getString(key)!
          : defaultValue;
    }

    return defaultValue;
  }

  static void setIntValue(String key, int value) {
    final SharedPreferences sharedPreferences = UserDefaults.sharedPreferences!;

    sharedPreferences.setInt(key, value);
  }

  static int getIntValue(String key, int defaultValue) {
    final SharedPreferences sharedPreferences = UserDefaults.sharedPreferences!;

    return sharedPreferences.getInt(key) ?? defaultValue;
  }

  static saveUserSession(UserLoginResponseModel loginResponseModel) async {
    String user = json.encode(loginResponseModel.toJson());
    await getPref().then((value) => value..setString('userData', user));
    printWrapped("user session saved");
  }

  static UserLoginResponseModel? getUserSession() {
    UserLoginResponseModel? user;
    if (sharedPreferences!.getString('userData') != null) {
      Map<String, dynamic> json =
          jsonDecode(sharedPreferences!.getString('userData')!);
      user = UserLoginResponseModel.fromJson(json);
      printWrapped(user.toString());
    }
    return user;
  }

  static setLanguage(String value) async {
    return await sharedPreferences?.setString('language', value);
  }

  static String? getLanguage() {
    return sharedPreferences?.getString('language');
  }

  static String? getApiToken() {
    return sharedPreferences?.getString('ApiToken');
  }

  static setApiToken(String value) async {
    return await sharedPreferences?.setString('ApiToken', value);
  }
}
