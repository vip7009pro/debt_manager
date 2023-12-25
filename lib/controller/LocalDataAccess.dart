import 'package:shared_preferences/shared_preferences.dart';

class LocalDataAccess {
  static Future saveVariable(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getVariable(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedVariable = prefs.getString(key) ?? '';
    return savedVariable;
  }
}
