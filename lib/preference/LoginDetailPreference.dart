import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Preferences.dart';

class LoginDetailPreference {
  static const USER_DETAIL = "USER_DETAIL";

  setUserData(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_DETAIL, value);
    log(Preferences.containsKey(LoginDetailPreference.USER_DETAIL).toString());
  }

  Future<String> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_DETAIL) ?? '';
  }
}
