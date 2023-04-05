import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../ui/model/user.dart';
import '../utility/project_util.dart';

class PrefService {
  Future saveUser(User user) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(ProjectUtil.PREF_REMEMBER_ME, user.isRemember!);
    _preferences.setString(ProjectUtil.PREF_USER_NAME, user.name!);
    _preferences.setString(ProjectUtil.PREF_PASSWORD, user.password!);
    _preferences.setBool(ProjectUtil.PREF_ISADMIN, user.isAdmin!);
  }

  Future<User> getUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var isRemember = _preferences.getBool(ProjectUtil.PREF_REMEMBER_ME);
    var name = _preferences.getString(ProjectUtil.PREF_USER_NAME);
    var password = _preferences.getString(ProjectUtil.PREF_PASSWORD);
    var isAdmin = _preferences.getBool(ProjectUtil.PREF_ISADMIN);
    return User(name, password,isRemember,isAdmin);
  }

  Future clearUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove(ProjectUtil.PREF_REMEMBER_ME);
    _preferences.remove(ProjectUtil.PREF_USER_NAME);
    _preferences.remove(ProjectUtil.PREF_PASSWORD);
    _preferences.remove(ProjectUtil.PREF_ISADMIN);
    exit(0);
  }
}
